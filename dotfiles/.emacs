;; <[magit]>: <magit>

(require 'use-package-ensure)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(use-package fontset
  :straight (:type built-in) ;; only include this if you use straight
  :config
  ;; Use symbola for proper unicode
  (when (member "Symbola" (font-family-list))
    (set-fontset-font
     t 'symbol "Symbola" nil)))        

(setq use-package-always-ensure t)
(setq vc-follow-symlinks t)
(setq custom-safe-themes t)
(global-set-key (kbd "M-p") 'previous-buffer)
(global-set-key (kbd "M-n") 'next-buffer)
(global-set-key (kbd "C-;") 'execute-extended-command)
(global-set-key "\C-\\" #'(lambda nil (interactive) (kbd-key:act "hga"))) 
(global-set-key (kbd "M-<return>") 'hkey-either)
(global-set-key (kbd "M-RET") 'hkey-either)
(global-set-key (kbd "s-<return>") 'hkey-either) 

(use-package package
  :custom
  (package-archives '(("gnu" . "https://elpa.gnu.org/packages/") ("melpa-stable" . "https://stable.melpa.org/packages/") ("cselpa" . "https://elpa.thecybershadow.net/packages/")))
  (package-selected-packages
   '(term-keys magit hyperbole vertico consult consult-dir embark embark-consult marginalia popper orderless modus-themes))

  :config
  (package-initialize)
  (unless package-archive-contents
    (package-refresh-contents))
  (package-install-selected-packages :noconfirm))

(require 'term-keys)
(term-keys-mode t)

(use-package recentf
  :bind ("C-x C-r" . recentf-open))

(use-package hyperbole
  :init
  :demand t
  :config
  (hyperbole-mode 1))

(use-package vertico
  :init
  (vertico-mode 1))

(use-package marginalia
  :init
  (marginalia-mode 1))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-override '((file (styles basic partial-completion)))))

(use-package embark
  :bind
  (("M-." . embark-act)         
   ("C-." . embark-dwim))        
  :init
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))
(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package popper
  :bind (("C-`"   . popper-toggle)
         ("M-`"   . popper-cycle)
         ("C-M-`" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
	  "Output\\*$"
	  "*Buffer List*"
          "\\*Async Shell Command\\*"
          help-mode
          compilation-mode))
  (popper-mode +1)
  (popper-echo-mode +1))            

(use-package consult
  :bind (("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ("C-x M-:" . consult-complex-command)    
         ("C-x b" . consult-buffer)               
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame) 
         ("C-x t b" . consult-buffer-other-tab)   
         ("C-x r b" . consult-bookmark)           
         ("C-x p b" . consult-project-buffer)     
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)     
         ("C-M-#" . consult-register)
         ("M-y" . consult-yank-pop)        
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g o" . consult-outline)    
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ("M-s d" . consult-find)    
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)  
         ("M-s e" . consult-isearch-history)
         ("M-s l" . consult-line)           
         ("M-s L" . consult-line-multi)     
         :map minibuffer-local-map
         ("M-s" . consult-history)           
         ("M-r" . consult-history))          

  :hook (completion-list-mode . consult-preview-at-point-mode)

  :init

  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  (advice-add #'register-preview :override #'consult-register-window)

  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  :config

  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   :preview-key '(:debounce 0.4 any))
)

(use-package consult-dir
  :bind (("C-x C-d" . consult-dir)
	 :map minibuffer-local-completion-map
	 ("C-x C-d" . consult-dir)
	 ("C-x C-j" . consult-dir-jump-file)))

(use-package magit)

(use-package spacious-padding
  :config
  (spacious-padding-mode t))

(use-package lambda-themes
  :straight (:type git :host github :repo "lambda-emacs/lambda-themes") 
  :custom
  (lambda-themes-set-italic-comments t)
  (lambda-themes-set-italic-keywords t)
  (lambda-themes-set-variable-pitch t) 
  :config
  ;; load preferred theme 
  (load-theme 'lambda-dark)
  )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(gnus-inhibit-startup-message t)
 '(hmouse-middle-flag t)
 '(inhibit-startup-screen t)
 '(lambda-line-position 'top)
 '(lambda-line-prefix-padding t)
 '(lambda-themes-set-vibrant t)
 '(org-fold-core-style 'overlays)
 '(package-selected-packages
   '(spacious-padding term-keys magit hyperbole vertico consult consult-dir embark embark-consult marginalia popper orderless modus-themes) nil nil "Customized with use-package package")
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style 'post-forward nil (uniquify))
 '(use-short-answers t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 160 :width normal :foundry "nil" :family "Iosevka Comfy"))))
 '(fringe ((t :background "White")))
 '(header-line ((t :box (:line-width 4 :color "grey90" :style nil))))
 '(header-line-highlight ((t :box (:color "Black"))))
 '(keycast-key ((t)))
 '(lambda-line-visual-bell ((t nil)))
 '(line-number ((t :background "White")))
 '(mode-line ((t :box (:line-width 6 :color "grey75" :style nil))))
 '(mode-line-active ((t :box (:line-width 6 :color "grey75" :style nil))))
 '(mode-line-highlight ((t :box (:color "Black"))))
 '(mode-line-inactive ((t :box (:line-width 6 :color "grey90" :style nil))))
 '(tab-bar-tab ((t :box (:line-width 4 :color "grey85" :style nil))))
 '(tab-bar-tab-inactive ((t :box (:line-width 4 :color "grey75" :style nil))))
 '(tab-line-tab ((t)))
 '(tab-line-tab-active ((t)))
 '(tab-line-tab-inactive ((t)))
 '(vertical-border ((t :background "White" :foreground "White")))
 '(window-divider ((t (:background "White" :foreground "White"))))
 '(window-divider-first-pixel ((t (:background "White" :foreground "White"))))
 '(window-divider-last-pixel ((t (:background "White" :foreground "White")))))

;; Set $DICPATH to "$HOME/Library/Spelling" for hunspell.
(setenv
  "DICPATH"
  (concat (getenv "HOME") "/Library/Spelling"))
;; Tell ispell-mode to use hunspell.
(setq
  ispell-program-name
  "/opt/homebrew/bin/hunspell")

;; (use-package solo-jazz-theme
;;   :ensure t
;;   :config
;;   (load-theme 'solo-jazz t))

;; (menu-bar-mode 0)
;; (load-theme 'doom-one)

(winner-mode t)
(global-set-key "\M-;" 'comment-line)
