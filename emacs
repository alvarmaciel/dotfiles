;; -*- lisp -*-

;; Emacs packages used by this config file:
;; auctex	integrated document editing environment for TeX etc.
;; bbdb		The Insidious Big Brother Database (email rolodex) for Emacs
;; cscope	Interactively examine a C program source
;; debian-el	Emacs helpers specific to Debian users
;; devscripts-el
;; dpkg-dev-el	Emacs helpers specific to Debian development
;; emacsen-common	Common facilities for all emacsen
;; emacs-goodies-el	Miscellaneous add-ons for Emacs
;; erc		an IRC client for Emacs
;; gnus		A versatile News and mailing list reader for Emacsen.
;; gnus-bonus-el Miscellaneous add-ons for Gnus
;; gnuserv	Allows you to attach to an already running Emacs
;; mule-ucs	universal encoding system for Mule
;; muse-el	Author and publish projects using Wiki-like markup
;; planner-el	personal information manager for Emacs
;; remember-el	remember text within Emacs
;; speedbar	Everything browser, or Dired on steroids
;; w3m-el	simple Emacs interface of w3m
;; planner-el	personal information manager for Emacs

;; Planed to be used:
;; namazu2	Full text search engine (namazu binary and cgi)v

(add-to-list 'load-path "~/.elisp")
(add-to-list 'load-path "~/.elisp/g-client")
(load-library "g")
(setq g-user-email "0xa1f00@gmail.com")

(add-to-list 'load-path "~/.elisp/google")

(require 'google-contacts)
(require 'google-calendar)

(setq google-contacts-user           "0xa1f00@gmail.com")
(setq google-contacts-code-directory "~/.elisp/google/code")
(setq google-contacts-directory      "/tmp")
(setq google-contacts-auto-update    t )
(setq google-calendar-url            "https://www.google.com/calendar/ical/0xa1f00%40gmail.com/private-a7a66d7c1aadc4236f06bb3a0372bd5d/basic.ics")
(setq google-calendar-user           "0xa1f00@gmail.com")
(setq google-calendar-code-directory "~/.elisp/google/code")
(setq google-calendar-directory      "/tmp")
(setq google-calendar-auto-update    t )

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(unless (require 'el-get nil t)
  (url-retrieve
   "https://github.com/dimitri/el-get/raw/master/el-get-install.el"
   (lambda (s)
     (end-of-buffer)
     (eval-print-last-sexp))))

(setq el-get-sources
      '((:name bbdb
	       :after (lambda () (require 'xa1-bbdb)))
	(:name erc
	       :after (lambda () (require 'xa1-erc)))
	(:name twittering-mode
	       :after (lambda () (require 'xa1-twittering)))

	(:name naquadah-theme
	       :after (lambda ()		       ;; Theme
		       (require 'naquadah-theme)
		       (setq window-system-default-frame-alist
			     '((x
				(alpha . 95)
				(font . "ProFontWindows-10")
				)))
		       (set-fringe-style 'half)
		       (setq indicate-buffer-boundaries 'left)))
		       ;;    (set-fontset-font (frame-parameter nil 'font)
	;;      'han '("cwTeXHeiBold" . "unicode-bmp"))

	(:name org-mode
	       :after (lambda () (require 'xa1-org)))

	(:name google-maps
	       :after (lambda () (require 'org-location-google-maps)
			(message "Org google maps")))
	(:name google-weather
	       :after (lambda () (require 'org-google-weather)
			 (message "Org google weather")
			 (setq org-google-weather-format "%i %-15L, %-15c, %2l-%-2h %s")))

	(:name remember
	       :after (lambda ()			 ;; Remember
			(when (require 'org-remember nil t)
			  (progn
			   (org-remember-insinuate)

			   (setq remember-annotation-functions '(org-remember-annotation))
			   (setq remember-handler-functions '(org-remember-handler))
			   (add-hook 'remember-mode-hook 'org-remember-apply-template)

			   (autoload 'remember "remember" nil t)
			   (autoload 'remember-region "remember" nil t)

			   (define-key global-map "\M-R" 'remember-region)))))

	(:name git-commit-mode
	       :after (lambda () (add-hook 'git-commit-mode-hook 'turn-on-flyspell)
		       (setq git-append-signed-off-by t)
		       (add-hook 'git-commit-mode-hook (lambda () (toggle-save-place 0)))))
	;;     (:name bongo
	;;	    :after (lambda () (autoload 'bongo "bongo"
	;;				"Start Bongo by switching to a Bongo buffer.")))
	(:name magit
	       :after (lambda () (global-set-key (kbd "C-x C-z") 'magit-status)
			(setq magit-commit-signoff t)))
	(:name coffee-mode
	       :after (lambda()
			(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
			(add-to-list 'auto-mode-alist '("Cakefile" . coffee-mode))))
))

(setq xa1-packages
      (append
       '(cssh
	 js2-mode
	 el-get
	 vkill
	 nxhtml
	 xcscope
	 yasnippet
	 gitsum
	 nognus
	 gnus-gravatar
	 gnus-identities
	 pymacs
	 ropemacs
	 python-mode
	 offlineimap
	 erc-extras
	 erc-highlight-nicknames
	 erc-track-score)
       (mapcar 'el-get-source-name el-get-sources)))

(el-get 'sync xa1-packages)


(if (string-match "ads.local" (system-name))
    (progn
      (message "we are @sagemcom")
      (autoload 'smtpmail-send-it "smtpmail")
      (setq user-mail-address "niv.sardi@sagemcom.com")
      (setq smtpmail-smtp-server "vzy08031.vzy.sagem"
	    smtpmail-local-domain "sagemcom.com")

      (setq send-mail-function 'smtpmail-send-it)
      (setq message-send-mail-function 'smtpmail-send-it)

      (setq smtp-service "smtp")

      ;;(setq socks-override-functions 1)
      ;;(setq socks-noproxy '("localhost" "*.sagem" "*.local"))
      ;;(when (require 'socks nil nil)
;;	(setq socks-server '("Default server" "localhost" 9999 5))
	;;(setq erc-server-connect-function 'socks-open-network-stream)
	;;(defalias 'open-network-stream 'socks-open-network-stream)
	;;(defalias 'open-network-stream 'socks-original-open-network-stream)
	;;(setq erc-server-connect-function 'open-network-stream)
;;	))
)
  (progn ;; else
    (message "default settings")
    (setq send-mail-function 'smtpmail-send-it
	  starttls-use-gnutls t
	  message-send-mail-function 'smtpmail-send-it
	  smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
	  smtpmail-auth-credentials '(("smtp.gmail.com" 587 "0xa1f00@gmail.com" nil))
	  smtpmail-smtp-server "smtp.gmail.com"
	  smtpmail-smtp-service 587
	  smtpmail-debug-info t)
    (require 'smtpmail)))

(add-to-list 'load-path "~/.emacs.d/")
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")
  (when (require 'auto-complete-clang nil t)
    (defun xa1/ac-cc-mode-setup ()
      (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))

    (add-hook 'c-mode-common-hook 'xa1/ac-cc-mode-setup)
    (ac-config-default)

    (setq ac-auto-start nil)
    (setq ac-quick-help-delay 0.5)
    (ac-set-trigger-key "TAB")))

(when (require 'doxymacs nil t) ;; this comes from README.Debian
  (add-hook 'c-mode-common-hook 'doxymacs-mode)
  (defun xa1/doxymacs-font-lock-hook ()
    (if (or (eq major-mode 'c-mode) (eq major-mode 'c++-mode))
        (doxymacs-font-lock)))
  (add-hook 'font-lock-mode-hook 'xa1/doxymacs-font-lock-hook))

;;(require 'tramp nil t)
(defvar find-file-root-prefix (if (featurep 'xemacs) "/[sudo/root@localhost]" "/sudo:root@localhost:" )
  "*The filename prefix used to open a file with `find-file-root'.")

(defvar find-file-root-history nil
  "History list for files found using `find-file-root'.")

(defvar find-file-root-hook nil
  "Normal hook for functions to run after finding a \"root\" file.")

(defun find-file-root ()
  "*Open a file as the root user.
   Prepends `find-file-root-prefix' to the selected file name so that it
   maybe accessed via the corresponding tramp method."

  (interactive)
  (require 'tramp)
  (let* ( ;; We bind the variable `file-name-history' locally so we can
	 ;; use a separate history list for "root" files.
	 (file-name-history find-file-root-history)
	 (name (or buffer-file-name default-directory))
	 (tramp (and (tramp-tramp-file-p name)
		     (tramp-dissect-file-name name)))
	 path dir file)

    ;; If called from a "root" file, we need to fix up the path.
    (when tramp
      (setq path (tramp-file-name-localname tramp)
	    dir (file-name-directory path)))

    (when (setq file (ido-read-file-name "Find file (UID = 0): " dir path))
      (find-file (concat find-file-root-prefix file))
      ;; If this all succeeded save our new history list.
      (setq find-file-root-history file-name-history)
      ;; allow some user customization
      (run-hooks 'find-file-root-hook))))

(global-set-key [(control x) (control r)] 'find-file-root)

;;(require 'mule)
;;(require 'un-define)
(when (require 'term-xaiki nil t)
  (when (require 'multi-term nil t)
    (setq term-term-name "eterm-color")
    (global-set-key [?\M-\C-t] 'multi-term)
    (defun term-send-up    () (interactive) (term-send-raw-string "\e[A"))
    (defun term-send-down  () (interactive) (term-send-raw-string "\e[B"))
    (defun term-send-right () (interactive) (term-send-raw-string "\e[C"))
    (defun term-send-left  () (interactive) (term-send-raw-string "\e[D"))
    (defun term-send-home  () (interactive) (term-send-raw-string "\e[F"))
    (defun term-send-Cr  () (interactive) (term-send-raw-string ""))
    (define-key term-raw-map "\C-r" 'term-send-Cr)
    ))

(require 'cl nil t)

(setq-default scroll-step 1)  ; turn off jumpy scroll
(setq-default visible-bell t) ; no beeps, flash on errors
;; Syntaxe highlighting pour tout
;;css
(setq cssm-indent-function #'cssm-c-style-indenter)
(setq cssm-indent-level 8)

(require 'git nil t)
(require 'git-blame nil t)
(require 'vc-git nil t)

;;(require 'ecb)

(when (require 'font-lock nil t)
  (setq initial-major-mode
	(lambda ()
	  (text-mode)
	  (font-lock-mode)))
  (setq font-lock-mode-maximum-decoration t
	font-lock-use-default-fonts t
	font-lock-use-default-colors t)

  (setq font-lock-maximum-size nil)	; trun off limit on font lock mode
  (global-font-lock-mode t)
  )
(setq indicate-buffer-boundaries 'left)

(when (if (= emacs-major-version 23)
	   (require 'w3m-load nil t)
	   (require 'w3m nil t))
  (require 'mime-w3m nil t)
;;  (define-key w3m-mode-map [up] 'previous-line)
;;  (define-key w3m-mode-map [down] 'next-line)
;;  (define-key w3m-mode-map [left] 'backward-char)
;;  (define-key w3m-mode-map [right] 'forward-char)
  (setq w3m-key-binding 'info)
  (setq browse-url-browser-function 'w3m-browse-url)
  (global-set-key "\C-xm" 'browse-url-at-point)
  (global-set-key "\C-xw" 'w3m)
  (setq w3m-use-cookies t)
  (setq w3m-cookie-accept-bad-cookies t)
  (remove-hook 'w3m-mode-hook 'w3m-type-ahead-mode)
)

(require 'gnus)
(require 'message)
; Ajout de la date ,de l'heure,de la ligne et de la colonne dans la modeline
(setq display-time-string-forms
      '((format "[%s:%s]-[%s/%s/%s]" 24-hours minutes day month year)))
(setq line-number-mode t)
(setq display-time-24hr-format t)
(setq column-number-mode t)
(display-time)

(setq next-line-add-newlines t)
(setq scroll-preserve-screen-position t); pour pouvoir scroller normalement
(auto-compression-mode t)               ; permet d'ouvrir les gz a la volee
(transient-mark-mode t)

;;---
(require 'dbus)
(defvar nm-dbus-registration nil)
(setq nm-dbus-registration nil)
(defvar nm-connected-hook nil
  "Functions to run when network is connected.")
(defvar nm-connecting-hook nil
  "Functions to run when network is connecting.")
(defvar nm-disconnected-hook nil
  "Functions to run when network is disconnected.")

(defun nntp-nuke-server-processes()
 "Brutally kill running NNTP server background processes. Useful
when Gnus hangs on network outs or changes."
  (interactive)
  (let ((sm (if gnus-select-method
                (cons gnus-select-method gnus-secondary-select-methods)
              gnus-secondary-select-methods)))
    (while sm
      (let ((method (car (car sm)))
            (vserv (nth 1 (car sm))))
        (when (and (eq 'nntp method)
                   (buffer-local-value 'nntp-process (get-buffer (nntp-find-connection-buffer vserv))))
          (gnus-message 6 "Killing NNTP process for server %s" vserv)
          (delete-process (buffer-local-value 'nntp-process (get-buffer (nntp-find-connection-buffer vserv))))))
      (setq sm (cdr sm)))))

(defun gnus-nm-agent-unplug()
  "Kill IMAP server processes and unplug Gnus agent."
  (gnus-message 6 "Network is disconnected, unplugging Gnus agent.")
  (with-current-buffer gnus-group-buffer
    ;;(nntp-nuke-server-processes) ; optional, help prevent hangs in IMAP processes when network has gone down.
    (gnus-agent-toggle-plugged nil))
  (when (offlineimap-kill) (message "killed offlineimap"))
  )

(defun gnus-nm-agent-plug()
  "Plug Gnus agent."
  (gnus-message 6 "Network is connected, plugging Gnus agent.")
  (with-current-buffer gnus-group-buffer
    (gnus-agent-toggle-plugged t))
  (when (offlineimap) (message "launched offlineimap"))
  )

(defun nm-state-dbus-signal-handler (nmstate)
  "Handles NetworkManager signals and runs appropriate hooks."
  (cond ((= 20 nmstate)
	   (progn (message "Network changed: disconnected")
		  (run-hooks 'nm-disconnected-hook)))
	  ((= 70 nmstate)
	   (progn (message "Network changed: connected")
		  (run-hooks 'nm-connected-hook)))
	  ((= 40 nmstate)
	   (progn (message "Network changed: connecting")
		  (run-hooks 'nm-connecting-hook)))
	  (t (message "unhandled Network change state %d" nmstate))))

(defun nm-enable()
  "Enable integration with NetworkManager."
  (interactive)
  (when (not nm-dbus-registration)
    (progn (setq nm-dbus-registration
                 (dbus-register-signal :system
                  "org.freedesktop.NetworkManager" "/org/freedesktop/NetworkManager"
                  "org.freedesktop.NetworkManager" "StateChanged"
                  'nm-state-dbus-signal-handler))
           (message "Enabled integration with NetworkManager"))))

(defun nm-disable()
  "Disable integration with NetworkManager."
  (interactive)
  (when nm-dbus-registration
      (progn (dbus-unregister-object nm-dbus-registration)
             (setq nm-dbus-registration nil)
             (message "Disabled integration with NetworkManager"))))

;; Add hooks for plugging/unplugging on network state change:
(add-hook 'nm-connected-hook 'gnus-nm-agent-plug)
(add-hook 'nm-disconnected-hook 'gnus-nm-agent-unplug)

;; If you want to start up Gnus in offline or online state depending on the current network status, you can add a custom Gnus startup function in ~/.emacs, something like this:

(defun nm-is-connected()
  (equal 3 (dbus-get-property
            :system "org.freedesktop.NetworkManager" "/org/freedesktop/NetworkManager"
            "org.freedesktop.NetworkManager" "State")))
(defun switch-to-or-startup-gnus ()
  "Switch to Gnus group buffer if it exists, otherwise start Gnus in plugged or unplugged state,
depending on network status."
  (interactive)
  (if (or (not (fboundp 'gnus-alive-p))
          (not (gnus-alive-p)))
      (if (nm-is-connected)
          (progn
	    (gnus)
	    (offlineimap))
        (gnus-unplugged))
    (switch-to-buffer gnus-group-buffer)
    (delete-other-windows)))

(nm-enable)

(require 'iedit nil t)

(when (require 'browse-kill-ring nil 'noerror)
  (browse-kill-ring-default-keybindings))

(global-set-key "\C-cy" '(lambda ()
   (interactive)
   (popup-menu 'yank-menu)))

;; this replaces iswitchb
(when (require 'ido nil t)
  (ido-mode t)

  (setq ido-default-buffer-method 'maybe-frame
	ido-default-file-method 'maybe-frame
	ido-enable-flex-matching t)

  (defun xa1/ido-reset-command-cache ()
    "Reset the ido cache"
    (interactive)
    (setq xa1/ido-execute-command-cache nil))

  (xa1/ido-reset-command-cache)
  (defun xa1/ido-execute-command ()
    (interactive)
    (call-interactively
     (intern
      (ido-completing-read
       "M-x "
       (progn
	 (unless xa1/ido-execute-command-cache
	   (mapatoms (lambda (s)
		       (when (commandp s)
			 (setq xa1/ido-execute-command-cache
			       (cons (format "%S" s) xa1/ido-execute-command-cache))))))
	 xa1/ido-execute-command-cache)))))

  (add-hook 'ido-setup-hook
	    (lambda ()
	      (global-set-key "\M-x" 'xa1/ido-execute-command)))

  (defun xa1/ido-find-tag ()
    "Find a tag using ido"
    (interactive)
    (tags-completion-table)
    (let (tag-names)
      (mapc (lambda (x)
              (unless (integerp x)
                (push (prin1-to-string x t) tag-names)))
            tags-completion-table)
      (find-tag (ido-completing-read "Tag: " tag-names))))
  )

(if (require 'hl-line)
    (progn
      (set-face-background 'hl-line "yellow4")
))

(when (require 'ibuffer nil t)
  (setq ibuffer-saved-filter-groups
	(quote (("default"
		 ("Org" ;; all org-related buffers
		  (mode . org-mode))
		 ("Mail"
		  (or  ;; mail-related buffers
               (mode . message-mode)
               (mode . mail-mode)
	       (mode . gnus)
	       (mode . gnus-article-mode)
	       (mode . gnus-summary-mode)
	       (mode . gnus-group-mode)
               ;; etc.; all your mail related modes
               ))
            ("FFMPEG"
              (filename . "Wrk/FFMPEG"))
            ("Icecast"
	     (filename . "Wrk/FF-Replace")
	     (filename . "Wrk/Icecast"))
            ("Wrk"
              (filename . "Wrk"))
	    ("Programming" ;; prog stuff not already in MyProjectX
              (or
                (mode . c-mode)
                (mode . perl-mode)
                (mode . python-mode)
                (mode . emacs-lisp-mode)
		(mode . cscope-mode)
		(mode . cpp-mode)
                ;; etc
                ))
	    ("Term" (mode . term-mode))
            ("ERC"   (mode . erc-mode))))))

(add-hook 'ibuffer-mode-hook
  (lambda ()
    (ibuffer-switch-to-saved-filter-groups "default")
    (hl-line-mode)
    ))

(global-set-key (kbd "C-x x") 'ibuffer)

  (global-set-key (kbd "C-x x") 'ibuffer)
  )

(when (require 'uniquify nil t)
  (setq uniquify-buffer-name-style 'forward))


(require 'iso-transl nil t)
;;(require 'utf-8)
(standard-display-8bit 160 255)
(set-input-mode t nil 0 7)
(set-language-environment 'UTF-8)

(defun recode-buffer ()
  "Recodes buffer in UTF-8"
  (interactive)
  (setq coding-system 'utf-8)
  (let ((buffer-read-only nil)
	(text (buffer-string)))
    (erase-buffer)
    (insert (decode-coding-string (string-make-unibyte text) coding-system)))
  )

(defun recode-region (start end &optional coding-system)
  "Replace the region with a recoded text."
  (interactive "r\n\zCoding System (utf-8): ")
  (setq coding-system (or coding-system 'utf-8))
  (let ((buffer-read-only nil)
	(text (buffer-substring start end)))
    (delete-region start end)
    (insert (decode-coding-string (string-make-unibyte text) coding-system))))

;; Un petit morceau de code qui permet de supprimer les espaces
;; qui restent en fin de ligne.
;; Origine :  lutzeb@cs.tu-berlin.de (Dirk Lutzebaeck) (1992)
(defun delete-trailing-space ()
  "Deletes trailing space from all lines in buffer."
  (interactive)
  (or buffer-read-only
      (save-excursion
        (message "Deleting trailing spaces ... ")
        (goto-char (point-min))
        (while (< (point) (point-max))
          (end-of-line nil)
          (delete-horizontal-space)
          (forward-line 1))
        (message "Deleting trailing spaces ... done.")))
  nil) ; indicates buffer-not-saved for write-file-hook
(define-key ctl-x-map " " 'delete-trailing-space)

;; la nouvelle fonction est associée au raccourci C-x espace

;; mpd
(if (require 'libempd nil t)
    (progn
      (setq empd-hostname "ayamaru.cxhome.ath.cx")
))

(when (require 'autopair nil t)
  (autopair-global-mode)
  (setq autopair-autowrap t)
  (setq autopair-blink t))

(defun match-paren (arg)
  "Go to the matching parenthesis."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
	((looking-at "\\s\)") (forward-char 1) (backward-list 1))
	(t (self-insert-command (or arg 1)))))

(global-set-key [(meta n)] 'gnus)
(global-set-key [(control \;)] 'comment-region)

;; EUDC
(require 'ldap)
;;(require 'eudc nil)
;; (setq ldap-host-parameters-alist
;;       (quote (("auth.dmz-int.fr.lan:636" base "ou=users,dc=smartjog,dc=lan"
;;                binddn "cn=Prenom NOM,ou=users,dc=smartjog,dc=lan"
;;                passwd "NO"))))

;; (setq eudc-default-return-attributes nil
;;       eudc-strict-return-matches nil)

;; (setq ldap-ldapsearch-args (quote ("-tt" "-LLL" "-x")))
;; (setq eudc-inline-query-format '((name)
;;                                  (firstname)
;;                                  (firstname name)
;;                                  (email)
;;                                  ))

;; (eudc-set-server "auth.dmz-int.fr.lan:636" 'ldap t)
;; (setq eudc-server-hotlist '(("auth.dmz-int.fr.lan:636" . ldap)))
;; (setq eudc-inline-expansion-servers 'hotlist)

;; (defun enz-eudc-expand-inline()
;;   (interactive)
;;   (move-end-of-line 1)
;;   (insert "*")
;;   (unless (condition-case nil
;;               (eudc-expand-inline)
;;             (error nil))
;;     (backward-delete-char-untabify 1))
;;   )

;; ;; Adds some hooks

;; (eval-after-load "message"
;;   '(define-key message-mode-map (kbd "TAB") 'enz-eudc-expand-inline))
;; (eval-after-load "sendmail"
;;   '(define-key mail-mode-map (kbd "TAB") 'enz-eudc-expand-inline))
;; (eval-after-load "post"
;;   '(define-key post-mode-map (kbd "TAB") 'enz-eudc-expand-inline))

;; replace y-e-s by y
(fset 'yes-or-no-p 'y-or-n-p)

;; pour le menu
;; Pour les personnes qui veulent le menu uniquement quand necessaire
;; control alt m affiche/efface le menu (On peut aussi faire M-x menu-bar-<B style="color:black;background-color:#A0FFFF">mode</B>)
;;(defun hideshow-menubar ()
  ;;  "affiche/enleve la menubar"
  ;; (interactive)
;;  (if (eq (specifier-specs menubar-visible-p 'global) 't)
;;      (set-specifier menubar-visible-p nil 'global)
;;    (set-specifier menubar-visible-p t 'global)
;;    )
;;  )
;; On associe la touche qui fera le swap du menu


(global-set-key [?\M-\C-'] 'menu-bar-mode)
(global-set-key [?\M-\C-,] 'tool-bar-mode)
(global-set-key [?\C-:]    'goto-line)

;; IRC buffers are constantly growing.  If you want to see as much as
;; possible at all times, you would want the prompt at the bottom of the
;; window when possible.  The following snippet uses a local value for
;; `scroll-conservatively' to achieve this:
(rcirc-track-minor-mode 1)
(add-hook 'rcirc-mode-hook
	  (lambda ()
	    (set (make-local-variable 'scroll-conservatively)
		 8192)))
;; The following code activates Fly Spell Mode for `rcirc' buffers:
     (add-hook 'rcirc-mode-hook (lambda ()
                                  (flyspell-mode 1)))

(setq rcirc-default-user-name "xaiki")
(setq rcirc-default-user-full-name "Niv Sardi")


;; If you're chatting from a laptop, then you might be familiar with
;; this problem: When your laptop falls asleep and wakes up later,
;; your IRC client doesn't realize that it has been disconnected.  It
;; takes several minutes until the client decides that the connection
;; has in fact been lost.  The simple solution is to use `M-x rcirc'.
;; The problem is that this opens an _additional_ connection, so
;; you'll have two copies of every channel buffer -- one dead and one
;; live.
;;   The real answer, therefore, is a `/reconnect' command:
(eval-after-load 'rcirc
  '(defun-rcirc-command reconnect (arg)
     "Reconnect the server process."
     (interactive "i")
     (unless process
       (error "There's no process for this target"))
     (let* ((server (car (process-contact process)))
	    (port (process-contact process :service))
	    (nick (rcirc-nick process))
	    channels query-buffers)
       (dolist (buf (buffer-list))
	 (with-current-buffer buf
	   (when (eq process (rcirc-buffer-process))
	     (remove-hook 'change-major-mode-hook
			  'rcirc-change-major-mode-hook)
	     (if (rcirc-channel-p rcirc-target)
		 (setq channels (cons rcirc-target channels))
	       (setq query-buffers (cons buf query-buffers))))))
       (delete-process process)
       (rcirc-connect server port nick
		      rcirc-default-user-name
		      rcirc-default-user-full-name
		      channels))))

;; Zenirc
;;(setq zenirc-server-alist
;;      '(("irc.freenode.net" nil nil "xaiki-emacs" nil)))

;; On supprime les menus et la scroll bar (vim-like)
(setq tool-bar-style 'image)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; On veut editer fvwmrc
(setq auto-mode-alist
      (append '(("\\.[A-Za-z]*wm$" . winmgr-mode)
		("\\.[A-Za-z]*wm2rc" . winmgr-mode))
	      auto-mode-alist))

(autoload 'winmgr-mode "winmgr-mode"
  "Mode for editing window manager config files")

(add-hook 'winmgr-mode-hook
        '(lambda ()
           (font-lock-mode t)
           (setq font-lock-keywords winmgr-font-lock-keywords)
           (font-lock-fontify-buffer)))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Torvalds a dit:
(defun linux-c-mode ()
  "C mode with adjusted values for the linux kernel."
  (interactive)
  (c-mode)
  (c-set-style "K&R")
  (setq tab-width 8)
  (setq indent-tabs-mode t)
  (setq c-basic-offset 8))

(setq tab-width 8)
(setq indent-tabs-mode t)
(setq c-basic-offset 8)
(setq perl-indent-level 8)
(setq sh-basic-offset 8)

(require 'pabbrev nil t)
(add-to-list 'auto-mode-alist '("~/src/.*linux.*/.*\\.[ch]$" . linux-c-mode))
(add-to-list 'auto-mode-alist '("*.make$" . makefile-gmake-mode))
(add-to-list 'auto-mode-alist '("Makefile.*" . makefile-gmake-mode))

(defun ffmpeg-c-mode ()
  "C mode with adjusted values for videolan."
  (interactive)
  (c-mode)
  (c-set-style "K&R")
  (setq tab-width 4)
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 4))

(defun vlc-c-mode ()
  "C mode with adjusted values for videolan."
  (interactive)
  (c-mode)
  (c-set-style "K&R")
  (setq tab-width 4)
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 4))

(defun sagem-c-mode ()
  "C mode with adjusted values for SAGEM."
  (interactive)
  (c-mode)
  (c-set-style "bsd")
  (setq tab-width 3)
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 3))

(add-to-list 'auto-mode-alist '("~/src/.*vlc.*/.*\\.[ch]$" . vlc-c-mode))
(add-to-list 'auto-mode-alist '("~/Wrk/.*[Ii]cecast.*/.*\\.[ch]$" . vlc-c-mode))
(add-to-list 'auto-mode-alist '("~/Wrk/.*[Ff][Ff][Mm].*/.*\\.[ch]$" . vlc-c-mode))

(when (require 'kbuild-mode nil t)
  (add-to-list 'auto-mode-alist '(".*Config\\.in.*" . kbuild-mode)))

;; C-Mode par défaut
;;(add-hook 'c-mode-common-hook
	  ;; (lambda () (c-toggle-auto-hungry-state 1))
;;	  ;; remap RET with C-j (newline-and-indent)
;;	  (lambda () (define-key c-mode-base-map "\C-m" 'c-context-line-break))
;;	  )
;;
;;(add-hook 'c-mode-common-hook
;;	  (lambda () (define-key c-mode-base-map "\:-m" 'goto-line))
;;	  )

;; Python
;; (require 'pycomplete)
;; (setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
;; (autoload 'python-mode "python-mode" "Python editing mode." t)
;; (autoload 'pymacs-load "pymacs" nil t)
;; (autoload 'pymacs-eval "pymacs" nil t)
;; (autoload 'pymacs-apply "pymacs")
;; (autoload 'pymacs-call "pymacs")
;; (setq interpreter-mode-alist(cons '("python" . python-mode)
;; 				  interpreter-mode-alist))

;; Hooks pour le texte
(add-hook 'text-mode-hook
	  '(lambda()
	     (flyspell-mode)
	     (turn-on-auto-fill)
	     (setq fill-column 70)))

;; shell-mode
;;(remove-hook 'comint-output-filter-functions
;;           'ansi-color-apply)
(setq shell-file-name "/bin/sh")
(setq ansi-color-for-comint-mode t)
(setq comint-prompt-read-only t)
(setq comint-move-point-for-output 'all)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(defun xa1-prompt-in-shell (&optional ignore)
  (backward-char 2)
  (while (search-forward "$" nil t) (replace-match (concat list-buffers-directory "$")nil t))
  )

(add-hook 'comint-output-filter-functions 'xa1-prompt-in-shell)
(add-hook 'comint-output-filter-functions
	     'comint-strip-ctrl-m)


;; ;; Eshell
;; (defun eshell/clear (&optional n) (recenter (if n n 0)))
;; (defun eshell/emacs (&rest files) (mapc 'find-file (mapcar 'expand-file-name files)))
;; (add-hook 'shell-mode-hook 'n-shell-mode-hook)
;; (defun n-shell-mode-hook ()
;;   "12Jan2002 - sailor, shell mode customizations."
;;   (local-set-key '[up] 'comint-previous-input)
;;   (local-set-key '[down] 'comint-next-input)
;;   (local-set-key '[(shift tab)] 'comint-next-matching-input-from-input)
;;   (setq comint-input-sender 'n-shell-simple-send)
;;   )

;; (defun n-shell-simple-send (proc command)
;;   "17Jan02 - sailor. Various commands pre-processing before sending to shell."
;;   (cond
;;    ;; Checking for clear command and execute it.
;;    ((string-match "^[ \t]*clear[ \t]*$" command)
;;     (comint-send-string proc "\n")
;;     (erase-buffer)
;;     )
;;    ;; Checking for man command and execute it.
;;    ((string-match "^[ \t]*man[ \t]*\\(.*\\)$" command)
;;     (comint-send-string proc "\n")
;;     (funcall 'man (replace-regexp-in-string "[ \t]*$" "" (match-string 1 command)))
;;     )

;;    ((string-match "^[ \t]*\\(?:emacs\\|vi\\)[ \t]*\\(.*\\)$" command)
;;     (comint-send-string proc "\n")

;;     ;;(message (format "command %s command" command))
;;     (funcall 'find-file-other-window (replace-regexp-in-string "[ \t]*$" "" (match-string 1 command)))
;;     )

;;    ((string-match "^[ \t]*\\(?:more\\|less\\)[ \t]*\\(.*\\)$" command)
;;     (comint-send-string proc "\n")

;;     ;;(message (format "command %s command" command))
;;     (funcall 'find-file-other-window (replace-regexp-in-string "[ \t]*$" "" (match-string 1 command)))
;;     )

;;    ;; Send other commands to the default handler.
;;    (t (comint-simple-send proc command))
;;    )
;;   )

;; Surligne les parenthèses
(show-paren-mode 1)
(blink-cursor-mode -1)

;; On zone quand emacs est inactif depuis t en secondes.
;;(require 'zone)
;; (zone-when-idle 600)

;; Gestion de la souris et de la molette
(setq mouse-wheel-mode t)
(defun up-slightly () (interactive) (scroll-up 5))
(defun down-slightly () (interactive) (scroll-down 5))
(global-set-key [mouse-4] 'down-slightly)
(global-set-key [mouse-5] 'up-slightly)

(defun up-one () (interactive) (scroll-up 1))
(defun down-one () (interactive) (scroll-down 1))
(global-set-key [S-mouse-4] 'down-one)
(global-set-key [S-mouse-5] 'up-one)

(defun up-a-lot () (interactive) (scroll-up))
(defun down-a-lot () (interactive) (scroll-down))
(global-set-key [C-mouse-4] 'down-a-lot)
(global-set-key [C-mouse-5] 'up-a-lot)

;;********************
;;
;; Fonctions lispiennes :
;;
;;********************

;; Fonction d'occurence
(defun call-occur()
(interactive)
(occur (current-word)))
(global-set-key (quote [f3]) 'call-occur)

;; On crée un backup directory pour avoir les "~" dans un seul et unique répertoire.
(defun make-backup-file-name (file)
  (concat "~/.backup/" (file-name-nondirectory file) "~"))

(mkdir "~/.backup" t)

(setq browse-url-epiphany-new-window-is-tab t)

;;**********
;;
;; Raccourci clavier F1, F2 ....
;;
;;********************

;; F1 libre

;; Permet de savoir ce qu'il reste dans la battery
(global-set-key (quote [f2]) 'battery)

;; F3 non-libre

;; Ferme un buffer rapidement
(global-set-key (quote [f4]) 'kill-this-buffer)

;; F5 libre
;; F6 libre
;; F7 libre
;; F8 libre

;; Compilation automatique
(global-set-key (quote [f9]) 'compile)

;; F10 libre

;; F11 libre

;; Next error
(global-set-key (quote [f12]) 'next-error)


(setq default-buffer-file-coding-system 'utf-8)
(setq file-name-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)

;; Calendar
(add-hook 'today-visible-calendar-hook 'calendar-mark-today)

;; Org mode
;; The following lines are always needed.  Choose your own keys.
(when (require 'org nil t)
)

(server-start)
;;(require 'gnuserv-compat)
;;(gnuserv-start)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(erc-modules (quote (autoaway autojoin button completion fill irccontrols list match menu move-to-prompt netsplit networks noncommands readonly ring scrolltobottom stamp spelling track)))
 '(gnus-summary-tool-bar (quote gnus-summary-tool-bar-gnome))
 '(indicate-buffer-boundaries t)
 '(js2-basic-offset 4)
 '(js2-bounce-indent-p t)
 '(js2-cleanup-whitespace t)
 '(js2-mirror-mode t)
 '(js2-mode-indent-ignore-first-tab nil)
 '(message-tool-bar (quote message-tool-bar-gnome))
 '(org-agenda-files (quote ("~/chela/xaiki-mece.org" "~/.org/TODO.org"))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(erc-current-nick-face ((((class color) (min-colors 65535)) (:foreground "yellow" :inherit (quote egocentric-face))) (t (:foreground "yellow" :inherit (quote egocentric-face))))))
