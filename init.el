(require 'use-package)

(use-package evil
  :custom
  (evil-want-minibuffer t)
  (evil-want-keybinding nil)
  :config
  (define-key evil-motion-state-map (kbd "<SPC>") nil)
  (evil-mode 1))

(use-package evil-collection
  :after evil lispy dired
  :config
  (evil-collection-init '(dired lispy vterm))

  (define-key evil-collection-lispy-mode-map
	      (kbd "<backspace>")
	      #'lispy-delete-backward)

  (lispy-define-key
      evil-collection-lispy-mode-map-special
      "d"
      #'evil-collection-lispy-delete))

(use-package vertico
  :bind
  (:map vertico-map
	("C-<return>" . #'vertico-exit-input))
  :config
  (vertico-mode 1))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
	completion-category-defaults nil
	completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :config
  (marginalia-mode 1))

(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 1)
  (corfu-auto-delay 0)
  :config
  (keymap-unset corfu-map "RET")
  (keymap-unset corfu-map "<enter>")
  (keymap-unset corfu-map "<up>")
  (keymap-unset corfu-map "<down>")
  (global-corfu-mode 1))


(use-package corfu-terminal
  :after corfu
  :config
  (unless (display-graphic-p)
    (corfu-terminal-mode +1)))

(use-package vterm
  :bind
  (:map evil-motion-state-map
	("<SPC> t" . vterm))
  :config
  (defvar vterm-new--index 0)
  (defun vterm-new (x)
    (interactive (list vterm-new--index))
    (if (get-buffer (format "%s<%d>"
			    vterm-buffer-name
			    x))
	(vterm-new (+ 1 x))
      (progn
	(setq vterm-new--index (+ 1 x))
	(vterm x)))))

(use-package eat
  :config
  (add-hook 'eshell-first-time-mode-hook
	    #'eat-eshell-visual-command-mode)

  (add-hook 'eshell-first-time-mode-hook #'eat-eshell-mode))

(use-package eglot)

(use-package dtrt-indent)

(use-package geiser-guile)

(use-package geiser-chez)

;; (use-package geiser-racket
;;   :config
;;   (geiser-activate-implementation 'racket))

(use-package geiser
  :custom
  (geiser-repl-use-other-window nil))

(use-package sly
  :custom
  (inferior-lisp-program "sbcl"))

(use-package sly-mrepl
  :after sly
  :load-path (lambda ()
	       (concat (file-name-directory (symbol-file 'sly))
		       "contrib/"))
  :bind
  (:map sly-mrepl-mode-map
	("<up>" . #'comint-previous-input)
	("<down>" . #'comint-next-input)))

(use-package lipsy
  :hook
  ((generic-lisp-mode . lispy-mode)))

(use-package aggressive-indent
  :hook
  ((prog-mode . (lambda ()
		  (unless (derived-mode-p 'python-base-mode)
		    (aggressive-indent-mode))))))

(use-package rainbow-delimiters
  :hook
  ((prog-mode . rainbow-delimiters-mode)
   ;; (geiser-repl-mode . rainbow-delimiters-mode)
   (generic-lisp-mode . rainbow-delimiters-mode))
  ;; :config
  ;; (add-hook #'inferior-emacs-lisp-mode-hook #'rainbow-delimiters-mode)
  )

(use-package prism)

(use-package flyspell
  :custom
  (ispell-program-name "aspell")
  (ispell-extra-args '("--sug-mode=ultra" "--lang=en_US" "--run-together" "--run-together-limit=16 --camel-case"))
  :hook
  ((text-mode . flyspell-mode)
   (prog-mode . flyspell-prog-mode)))

(use-package flycheck
  :config
  (global-flycheck-mode))

(use-package embark
  :bind
  (:map evil-motion-state-map
	("<SPC> a" . embark-act)))

;; (use-package which-key
;;   :custom
;;   (which-key-show-early-on-C-h t)
;;   (which-key-idle-delay 0)
;;   (which-key-idle-secondary-delay 0)
;;   :config
;;   (which-key-setup-minibuffer)
;;   (which-key-mode))

(use-package cape
  :custom
  (cape-dict-file (concat (getenv "HOME") "/Documents/Dicits/english"))
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  ;; (add-to-list 'completion-at-point-functions #'cape-sgml)
  ;; (add-to-list 'completion-at-point-functions #'cape-dict)
  )

(use-package tex
  :ensure auctex)

(use-package agda2-mode)

;; (use-package agda-input
;;   :hook
;;   ((agda2-mode . (lambda ()
;;		   (add-hook evil-insert-state-entry-hook
;;			     (lambda ()
;;			       (set-input-method "Agda"))
;;			     nil
;;			     t)
;;		   (add-hook evil-insert-state-exit-hook
;;			     (lambda ()
;;			       (set-input-method nil))
;;			     nil
;;			     t)))))

;; OCAML

(use-package tuareg
  :config
  (setq auto-mode-alist
	(cons '("\\.ml\\'" . tuareg-mode) auto-mode-alist)))

(use-package merlin
  :hook
  (tuareg-mode . merlin-mode))

;; END OCAML

(use-package magit)

(use-package mu4e
  :custom
  (mu4e-contexts
   `(,(make-mu4e-context
       :name "Outlook"
       :match-func
       (lambda (msg) (when msg (string-prefix-p "/Outlook")
			   (mu4e-message-field msg :maildir)))
       :vars
       '((mu4e-trash-folder . "/Outlook/Junk")
	 (mu4e-refile-folder . "/Outlook/Archive"))
       )))
  (smtpmail-servers-requiring-authorization
   ".*")
  :config
  (defvar mu4e-account-alist
    '(("Outlook"
       (mu4e-sent-folder "/Outlook/Sent/")
       (user-mail-address "m.kalandyk@outlook.com")
       (smtpmail-smtp-user "m.kalandyk@outlook.com")
       (smtpmail-local-domain "outlook.com")
       (smtpmail-default-smtp-server "smtp.office365.com")
       (smtpmail-smtp-server "smtp.office365.com")
       (smtpmail-stream-type starttls)
       (smtpmail-smtp-service 587))))

  (mapc (lambda (var)
	  (set (car var) (cadr var)))
	(cdar mu4e-account-alist))

  (defun mu4e-set-account ()
    "Set the account for composing a message.
   This function is taken from:
   https://www.djcbsoftware.nl/code/mu/mu4e/Multiple-accounts.html"
    (let* ((account
	    (if mu4e-compose-parent-message
		(let ((maildir (mu4e-message-field mu4e-compose-parent-message :maildir)))
		  (string-match "/\\(.*?\\)/" maildir)
		  (match-string 1 maildir))
	      (completing-read (format "Compose with account: (%s) "
				       (mapconcat #'(lambda (var) (car var))
						  mu4e-account-alist "/"))
			       (mapcar #'(lambda (var) (car var)) mu4e-account-alist)
			       nil t nil nil (caar mu4e-account-alist))))
	   (account-vars (cdr (assoc account mu4e-account-alist))))
      (if account-vars
	  (mapc #'(lambda (var)
		    (set (car var) (cadr var)))
		account-vars)
	(error "No email account found"))))
  (add-hook 'mu4e-compose-pre-hook 'mu4e-set-account))

;; Load agda

;; (load-file (let ((coding-system-for-read 'utf-8))
;;              (shell-command-to-string "agda-mode locate")))

;; GUIX
(use-package guix
  :custom
  (guix-dot-program "dot"))

(use-package guix-repl)

;; Built ins
(use-package emacs
  :custom
  (inhibit-startup-screen t)
  (completion-ignore-case t)
  (ring-bell-function 'ignore)
  (enable-recursive-minibuffers t)
  :config
  (defun enable-show-trailing-whitespace ()
    (setq-local show-trailing-whitespace t))
  (add-hook 'text-mode-hook #'enable-show-trailing-whitespace)
  (add-hook 'prog-mode-hook #'enable-show-trailing-whitespace))

(use-package repeat
  :config
  (repeat-mode))

(use-package whitespace
  :config
  (add-hook 'before-save-hook #'whitespace-cleanup)
  (defun whitespace-cleanup-local-disable ()
    (interactive)
    (remove-hook 'before-save-hook #'whitespace-cleanup)))

(use-package uniquify
  :custom
  (uniquify-buffer-name-style 'forward))

(use-package saveplace
  :config
  (save-place-mode 1))

(use-package files
  :config
  (defvar emacs-backups (expand-file-name "backups" user-emacs-directory))
  (defvar emacs-autosaves (expand-file-name "autosaves" user-emacs-directory))

  (make-directory emacs-backups t)
  (make-directory emacs-autosaves t)

  (setq backup-directory-alist `(("." . ,emacs-backups)))
  (setq auto-save-file-name-transforms
	`((,(rx
	     (zero-or-more any)
	     "/"
	     (group
	      (zero-or-more (not "/")))
	     string-end)
	   ,(concat
	     emacs-autosaves
	     "/\\1")
	   sha256)))

  (setq backup-by-copying t)
  (defadvice find-file (before make-directory-maybe (filename &optional wildcards) activate)
    "Create parent directory if not exists while visiting file."
    (unless (file-exists-p filename)
      (let ((dir (file-name-directory filename)))
	(unless (file-exists-p dir)
	  (make-directory dir t))))))

(use-package comint
  :bind
  (:map comint-mode-map
	("C-l" . #'comint-clear-buffer)
	("M-r" . #'comint-history-search)
	("S-<return>" . #'newline)
	("<left>" . #'comint-left)
	("<up>" . #'comint-up)
	("<down>" . #'comint-down))
  :config
  (defun line-pos (N)
    (save-excursion
      (goto-line N)
      (point)))

  (defun buffer-end-notwhite ()
    (save-excursion
      (goto-char (point-max))
      (skip-chars-backward "\n[")))

  (defun comint-up ()
    (interactive)
    (let* ((prompt (comint-line-beginning-position))
	   (prompt-line (line-number-at-pos prompt))
	   (current-line (line-number-at-pos (point))))
      (cond
       ((= prompt-line current-line) (call-interactively #'comint-previous-input))
       ((and (= (+ prompt-line 1) current-line)
	     (< (- (point) (line-pos current-line))
		(- prompt (line-pos prompt-line))))
	(goto-char prompt))
       (t (previous-line)))))

  (defun comint-down ()
    (interactive)
    (if (= (line-number-at-pos (point-max))
	   (line-number-at-pos (point)))
	(call-interactively #'comint-next-input)
      (next-line)))

  (defun comint-left ()
    (interactive)
    (let* ((prompt (comint-line-beginning-position))
	   (prompt-line (line-number-at-pos prompt))
	   (current-line (line-number-at-pos (point))))
      (if (= prompt-line current-line)
	  (if (> (- (point) (line-pos current-line))
		 (- prompt (line-pos prompt-line)))
	      (left-char))
	(left-char))))

  (defun comint-history-search ()
    (interactive)
    (if (and (ring-p comint-input-ring)
	     (not (ring-empty-p comint-input-ring)))
	(choose-completion-string
	 (if (= (ring-size comint-input-ring) 1)
	     (ring-ref comint-input-ring 0)
	   (completing-read "history: "
			    (ring-elements comint-input-ring)))
	 (current-buffer)))))

;; (use-package em-hist
;;   :bind
;;   (:map eshell-hist-mode-map
;;	("M-r" . #'comint-history-search)))


(use-package ielm
  :bind
  (:map inferior-emacs-lisp-mode-map
	("M-r" . #'comint-history-search))
  :config
  (defun ielm-init-history ()
    (let ((path (expand-file-name "ielm/history" user-emacs-directory)))
      (make-directory (file-name-directory path) t)
      (setq-local comint-input-ring-file-name path))
    (setq-local comint-input-ring-size 10000)
    (setq-local comint-input-ignoredups t)
    (comint-read-input-ring))

  (add-hook 'inferior-emacs-lisp-mode-hook #'ielm-init-history)

  (defun ielm-write-history (&rest _args)
    (with-file-modes #o600
      (comint-write-input-ring)))

  (advice-add 'ielm-send-input :after 'ielm-write-history))

(use-package window
  :custom
  (display-buffer-alist
   `(("\\*scratch\\*" display-buffer-same-window)
     ("\\*Occur\\*" display-buffer-pop-up-window))))

;; (use-package text-mode
;;   :hook
;;   (text-mode . auto-fill-mode))

;; (use-package windmove
;;   :config
;;   (windmove-install-defaults nil '(control)
;;			     '((windmove-swap-states-left left)
;;			       (windmove-swap-states-right right)
;;			       (windmove-swap-states-up up)
;;			       (windmove-swap-states-down down)))
;;   (windmove-install-defaults nil '(shift)
;;                              '((windmove-left left)
;;                                (windmove-right right)
;;                                (windmove-up up)
;;                                (windmove-down down))))

;; (use-package zoom
;;   :config
;;   (zoom-mode))

(use-package winner
  :config
  (winner-mode t))

(use-package tool-bar
  :config
  (tool-bar-mode -1))

(use-package scroll-bar
  :config
  (scroll-bar-mode -1))

(use-package display-line-numbers
  :hook
  ((prog-mode . #'display-relative-line-numbers)
   (text-mode . #'display-relative-line-numbers))
  :custom
  (display-line-numbers-type 'relative)
  :config
  (defun display-relative-line-numbers ()
    (interactive)
    (setq-local display-line-numbers 'relative)))

(use-package treesit
  :custom
  (major-mode-remap-alist
   '(;; (yaml-mode . yaml-ts-mode)
     (bash-mode . bash-ts-mode)
     (js-mode . js-ts-mode)
     (json-mode . js-json-ts-mode)
     (css-mode . css-ts-mode)
     (python-mode . python-ts-mode)
     (c-mode . c-ts-mode)
     (c++-mode . c++-ts-mode))))

(use-package electric
  :config
  (electric-pair-mode t))

;; prettify-symbols in fact
(use-package prog-mode
  :config
  (defun prettify-symbols-add (lst)
    (dolist (x lst)
      (add-to-list 'prettify-symbols-alist x)))

  (defun prettify-symbols-remove (lst)
    (dolist (x lst)
      (delete x 'prettify-symbols-alist)))

  (defmacro def-prettify-set-mode (name doc lst)
    (let ((mode-name
	   (intern (concat "prettify-"
			   (symbol-name name)
			   "-mode"))))
      `(define-minor-mode
	 ,mode-name
	 ,doc
	 :lighter nil
	 (if ,mode-name
	     (progn
	       (prettify-symbols-mode t)
	       (prettify-symbols-add ,lst))
	   (prettify-symbols-remove ,lst)))))

  (def-prettify-set-mode
   logic
   "Adds logic symbols"
   '(("implies" . ?⇒)
     ("equivalent" . ?≡)
     ("not" . ?¬)
     ("and" . ?∧)
     ("nand" . ?⊼)
     ("or" . ?∨)
     ("nor" . ?⊽)
     ("xor" . ?⊻)
     ("exist" . ?∃)
     ("therefore" . ?∴)
     ("because" . ?∵)
     ("proportional" . ?∷)
     ("!=" . ?≠)
     (">=" . ?≥)
     ("<=" . ?≤)
     ("forall" . ?∀)))

  (def-prettify-set-mode
   math-operations
   "Adds math symbols"
   '(("ratio" . ?∶)
     ("integral" . ?∫)
     ("sum" . ?⅀)
     ("-+" . ?∓)
     ("+-" . ?±)
     ("sqrt" . ?√)
     ("angle" . ?∠)))

  (def-prettify-set-mode
   set-theory
   "Adds set theory symbols"
   '(("intersection" . ?∩)
     ("union" . ?∪)
     ("in" . ?∈)
     ("member" . ?∋)
     ("subset" . ?⊂)
     ("superset" . ?⊃)
     ("null" . ?⍉)
     ("algebraic" . ?𝔸)
     ("transcendental" . ?𝕋)
     ("integer" . ?ℤ)
     ("complex" . ?ℂ)
     ("imaginary" . ?𝕀)
     ("quaternion" . ?ℍ)
     ("natural" . ?ℕ)
     ("prime" . ?ℙ)
     ("rational" . ?ℚ)
     ("real" . ?ℝ)))

  (def-prettify-set-mode
   greek-alphabet
   "Adds greek alphabet letters"
   '(("alpha" . ?α)
     ;; identical to A
     ("beta" . ?β)
     ;; identical to B
     ("gamma" . ?γ)
     ("Gamma" . ?Γ)
     ("delta" . ?δ)
     ("Delta" . ?Δ)
     ("epsilon" . ?ε)
     ("Epsilon" . ?Ε)
     ("zeta" . ?ζ)
     ;; identical to Z
     ("eta" . ?η)
     ;; identical to H
     ("theta" . ?θ)
     ("Theta" . ?Θ)
     ("iota" . ?ι)
     ;; Confusing with horizontal line
     ;; ("Iota" . ?Ι)
     ("kappa" . ?ϰ)
     ;; identical to K
     ("lambda" . ?λ)
     ("Lambda" . ?Λ)
     ("mu" . ?μ)
     ;; identical to M
     ("nu" . ?ν)
     ;; identical to N
     ("xi" . ?ξ)
     ("Xi" . ?Ξ)
     ;; No omicron identical to O
     ("pi" . ?π)
     ("Pi" . ?Π)
     ("rho" . ?ρ)
     ;; identical to P
     ("sigma" . ?σ)
     ("Sigma" . ?Σ)
     ("tau" . ?τ)
     ;; identical to T
     ("upsilon" . ?υ)
     ;; identical to Y
     ("phi" . ?φ)
     ("Phi" . ?Φ)
     ("chi" . ?χ)
     ;; identical to X
     ("psi" . ?ψ)
     ("Psi" . ?Ψ)
     ("omega" . ?ω)
     ("Omega" . ?Ω)))
  (add-hook 'generic-lisp-mode-hook #'prettify-greek-alphabet-mode))

(use-package server
  :config
  (unless (server-running-p)
    (server-start)))

;; General Functions

(defun reload-init ()
  (interactive)
  (let ((buf (get-file-buffer user-init-file)))
    (if buf
	(with-current-buffer buf
	  (eval-buffer))
      (with-temp-buffer
	(insert-file-contents user-init-file)
	(eval-buffer)))))

;; General modes

(define-minor-mode generic-lisp-mode
  "Mode ment to be used as hook for lisp modes")

(add-hook 'scheme-mode-hook #'generic-lisp-mode)
(add-hook 'emacs-lisp-mode-hook #'generic-lisp-mode)
(add-hook 'inferior-emacs-lisp-mode-hook #'generic-lisp-mode)
(add-hook 'geiser-repl-mode-hook #'generic-lisp-mode)
(add-hook 'lisp-mode-hook #'generic-lisp-mode)
(add-hook 'lisp-interaction-mode-hook #'generic-lisp-mode)
(add-hook 'sly-mrepl-hook #'generic-lisp-mode)

;; Keybindings
(defmacro defun-bind (NAME ARGLIST KEYMAP KEY
			   &optional DOCSTRING DECL
			   &rest BODY)
  `(progn
     (defun ,NAME ,ARGLIST ,DOCSTRING (interactive) ,DECL ,BODY)
     (define-key ,KEYMAP ,(kbd KEY) (quote ,NAME))))

(defun-bind open-init ()
	    evil-motion-state-map
	    "<SPC> i"
	    (find-file user-init-file))

(defun-bind open-scratch ()
	    evil-motion-state-map
	    "<SPC> s"
	    (display-buffer (get-buffer-create "*scratch*")))


(defun-bind open-math ()
	    evil-motion-state-map
	    "<SPC> m"
	    (find-file (concat (getenv "HOME") "/Math")))

(defvar configurations
  (let ((home (getenv "HOME")))
    `((guix-system-config . "/etc/system-config/config.scm")
      (guix-home-config . ,(concat home "/src/guix-config/home-configuration.scm"))
      (guix-channels-config . ,(concat home "/.config/guix/channels.scm"))
      (emacs-init . ,user-init-file)
      (sway-config . ,(concat home "/.config/sway/config"))
      (ssh-home-config . ,(concat home "/.ssh/config")))))


(cl-flet ((extract (lambda (sym)
		     `(regexp ,(cdr (assoc sym configurations))))))
  (setq geiser-implementations-alist
	(append `((,(extract 'guix-system-config) guile)
		  (,(extract 'guix-home-config) guile)
		  (,(extract 'guix-channels-config) guile))
		geiser-implementations-alist)))

(defmacro make-config-opening-functions (configs)
  `(progn ,@(mapcar (lambda (config)
		      `(defun ,(intern (concat "open-" (symbol-name (car config)))) ()
			 (interactive)
			 (find-file ,(cdr config))))
		    (eval configs))))

(make-config-opening-functions configurations)

(defun-bind open-configs ()
	    evil-motion-state-map
	    "<SPC> c"
	    (find-file (cdr (assoc (intern (completing-read "Config: " configurations nil t))
				   configurations))))


(define-key evil-motion-state-map (kbd "<SPC> e r") #'eval-region)
(define-key evil-motion-state-map (kbd "<SPC> e b") #'eval-buffer)
(define-key evil-motion-state-map (kbd "<SPC> <SPC>") #'set-mark-command)

(define-key evil-motion-state-map (kbd "<SPC> r") nil)
(define-key evil-motion-state-map (kbd "<SPC> r g") #'geiser)
(define-key evil-motion-state-map (kbd "<SPC> r e") #'ielm)
(define-key evil-motion-state-map (kbd "<SPC> r l") #'sly)

;; Uses-full functions
(defun revert-watch (buffer-or-name)
  "Autoreverts buffer on file change"
  (interactive "b")
  (let* ((buffer (get-buffer buffer-or-name))
	 (file (buffer-file-name buffer)))
    (when (file-exists-p file)
      (file-notify-add-watch
       file
       '(change)
       (lambda (event)
	 (with-current-buffer
	     buffer
	   (revert-buffer nil t t)))))))

;; AUTOGENERATED
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(monokai))
 '(custom-safe-themes
   '("b1a691bb67bd8bd85b76998caf2386c9a7b2ac98a116534071364ed6489b695d" "19a2c0b92a6aa1580f1be2deb7b8a8e3a4857b6c6ccf522d00547878837267e7" "2ff9ac386eac4dffd77a33e93b0c8236bb376c5a5df62e36d4bfa821d56e4e20" "72ed8b6bffe0bfa8d097810649fd57d2b598deef47c992920aef8b5d9599eefe" "d80952c58cf1b06d936b1392c38230b74ae1a2a6729594770762dc0779ac66b7" "95b0bc7b8687101335ebbf770828b641f2befdcf6d3c192243a251ce72ab1692" "f4835f97c034b7f3c512b177bbaebebee35d11baa0c9b95a9029e45962bc34c8" default))
 '(safe-local-variable-values
   '((geiser-repl-per-project-p . t)
     (eval progn
	   (require 'lisp-mode)
	   (defun emacs27-lisp-fill-paragraph
	       (&optional justify)
	     (interactive "P")
	     (or
	      (fill-comment-paragraph justify)
	      (let
		  ((paragraph-start
		    (concat paragraph-start "\\|\\s-*\\([(;\"]\\|\\s-:\\|`(\\|#'(\\)"))
		   (paragraph-separate
		    (concat paragraph-separate "\\|\\s-*\".*[,\\.]$"))
		   (fill-column
		    (if
			(and
			 (integerp emacs-lisp-docstring-fill-column)
			 (derived-mode-p 'emacs-lisp-mode))
			emacs-lisp-docstring-fill-column fill-column)))
		(fill-paragraph justify))
	      t))
	   (setq-local fill-paragraph-function #'emacs27-lisp-fill-paragraph))
     (eval modify-syntax-entry 43 "'")
     (eval modify-syntax-entry 36 "'")
     (eval modify-syntax-entry 126 "'")
     (eval let
	   ((root-dir-unexpanded
	     (locate-dominating-file default-directory ".dir-locals.el")))
	   (when root-dir-unexpanded
	     (let*
		 ((root-dir
		   (file-local-name
		    (expand-file-name root-dir-unexpanded)))
		  (root-dir*
		   (directory-file-name root-dir)))
	       (unless
		   (boundp 'geiser-guile-load-path)
		 (defvar geiser-guile-load-path 'nil))
	       (make-local-variable 'geiser-guile-load-path)
	       (require 'cl-lib)
	       (cl-pushnew root-dir* geiser-guile-load-path :test #'string-equal))))
     (eval with-eval-after-load 'yasnippet
	   (let
	       ((guix-yasnippets
		 (expand-file-name "etc/snippets/yas"
				   (locate-dominating-file default-directory ".dir-locals.el"))))
	     (unless
		 (member guix-yasnippets yas-snippet-dirs)
	       (add-to-list 'yas-snippet-dirs guix-yasnippets)
	       (yas-reload-all))))
     (eval setq-local guix-directory
	   (locate-dominating-file default-directory ".dir-locals.el"))
     (eval add-to-list 'completion-ignored-extensions ".go")))
 '(send-mail-function 'smtpmail-send-it)
 '(warning-suppress-log-types '((comp)))
 '(warning-suppress-types '((comp) (comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
