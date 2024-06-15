(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package emacs
  :custom
  (custom-set-faces '(default ((t (:family "Consolas" :foundry "outline" :slant normal :weight regular :height 110 :width normal))))))

(use-package package
  :custom
  (package-archives '(("gnu" . "https://elpa.gnu.org/packages/") ("melpa-stable" . "https://stable.melpa.org/packages/")))
  (package-selected-packages
   '(hyperbole vertico consult consult-dir embark embark-consult marginalia popper orderless modus-themes))

  :config
  (package-initialize)
  (unless package-archive-contents
    (package-refresh-contents))
  (package-install-selected-packages :noconfirm))

(use-package recentf
  :bind ("C-x C-r" . recentf-open))

(use-package hyperbole
  :demand t
  :config
  (hyperbole-mode 1))

(if (eq system-type 'darwin)
    (setq mac-command-modifier 'meta))

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
  (("C-." . embark-act)         
   ("C-;" . embark-dwim)        
   ("C-h B" . embark-bindings)) 
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
	  "*Scratch*"
	  "Output\\*$"
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

(use-package modus-themes
  :config
  (load-theme 'modus-operandi-tinted :no-confirm))


(use-package consult-dir
  :bind (("C-x C-d" . consult-dir)
	 :map minibuffer-local-completion-map
	 ("C-x C-d" . consult-dir)
	 ("C-x C-j" . consult-dir-jump-file)))

