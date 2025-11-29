;;;; Defaut settings
(setq inhibit-startup-message t)
(setq visible-bell t) ;; Set up the visible bell
(setq backup-directory-alist  '((".*" . "~/.Trash")))   ;; Move backup file in a directory in the root 
(global-set-key (kbd "<escape>") 'keyboard-escape-quit) ;; Make ESC quit prompts 


;;;; Add SML mode
(autoload 'sml-mode "sml-mode" "Major mode for editing SML." t)
(autoload 'run-sml "sml-proc" "Run an inferior SML process." t)

;;;; Add line numbers when you are in a progam mode
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setq linum-format "%3d ")
(line-number-mode t)
(column-number-mode t)


;;;; Theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;;(load-theme 'zenburn t)
(load-theme 'monokai-pro t)
;;(load-theme 'dracula t)
;;(load-theme 'wombat)
;;(load-theme 'misterioso)
(set-face-attribute 'default nil :font "Fira Code Retina" :height 280)


;;;; Mouse scrolling in terminal emacs
(unless (display-graphic-p)
  (xterm-mouse-mode 1)  ;; Enable mouse
  (global-set-key (kbd "<mouse-4>") 'scroll-down-line)  ;; activate mouse-based scrolling
  (global-set-key (kbd "<mouse-5>") 'scroll-up-line)
  )

;;;; Scroll mouse smooter
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time  
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling  
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse  
(setq scroll-step 1) ;; keyboard scroll one line at a time


;;;; CUA mode enable
(cua-mode t)
  (setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
  (transient-mark-mode 1) ;; No region when it is not highlighted 
  (setq cua-keep-region-after-copy t) ;; Standard Windows behaviour
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(monokai-theme sml-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; COPY FROM EMACS TO CLIPBOARD
(defun copy-from-osx ()
  (shell-command-to-string "pbpaste"))
(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))
(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx)
