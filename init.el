;; Add extra repos to package manager
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)

(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;; Load Theme
(load-theme 'solarized-light t)
;; (add-hook 'after-make-frame-functions
;;           (lambda (frame)
;;             (let ((mode (if (display-graphic-p frame) 'light 'dark)))
;;               (set-frame-parameter frame 'background-mode mode)
;;               (set-terminal-parameter frame 'background-mode mode))
;;             (enable-theme 'solarized)))


;; Custom functions
(defun clean-up-buffer-or-region ()
  "Untabifies, indents and deletes trailing whitespace from buffer or region."
  (interactive)
  (save-excursion
    (unless (region-active-p)
      (mark-whole-buffer))
    (untabify (region-beginning) (region-end))
    (indent-region (region-beginning) (region-end))
    (save-restriction
      (narrow-to-region (region-beginning) (region-end))
      (delete-trailing-whitespace))))

;; use only one desktop
(setq desktop-path '("~/.emacs.d/"))
(setq desktop-dirname "~/.emacs.d/")
(setq desktop-base-file-name "emacs-desktop")

;; remove desktop after it's been read
(add-hook 'desktop-after-read-hook
          '(lambda ()
             ;; desktop-remove clears desktop-dirname
             (setq desktop-dirname-tmp desktop-dirname)
             (desktop-remove)
             (setq desktop-dirname desktop-dirname-tmp)))

(defun saved-session ()
  (file-exists-p (concat desktop-dirname "/" desktop-base-file-name)))

;; use session-restore to restore the desktop manually
(defun session-restore ()
  "Restore a saved emacs session."
  (interactive)
  (if (saved-session)
      (desktop-read)
    (message "No desktop found.")))

;; use session-save to save the desktop manually
(defun session-save ()
  "Save an emacs session."
  (interactive)
  (if (saved-session)
      (if (y-or-n-p "Overwrite existing desktop? ")
          (desktop-save-in-desktop-dir)
        (message "Session not saved."))
    (desktop-save-in-desktop-dir)))

;; ask user whether to restore desktop at start-up
(add-hook 'after-init-hook
          '(lambda ()
             (if (saved-session)
                 (if (y-or-n-p "Restore desktop? ")
                     (session-restore)))))

;; OSX Custom settings
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))

;; Handle tabs
(setq-default indent-tabs-mode nil)

;; Expand region
(global-set-key (kbd "C-≤") 'er/expand-region)

;; Do not show startup message
(setq inhibit-startup-message t)

;; Auto refresh files on external changes
(global-auto-revert-mode t)

;; Keep emacs Custom-settings in separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; Appearance
;; -------------------------------------------------------------------------
(setq-default line-spacing 10)
(setq-default cursor-type 'bar)
(setq-default cursor-in-non-selected-windows 'hbar)

;; Show matching parens
(show-paren-mode 1)
(setq show-paren-delay 0)

;; Answer y or n instead of yes or no
(defalias 'yes-or-no-p 'y-or-n-p)

;; Global keybindings
;; -------------------------------------------------------------------------
;; Perform general cleanup.
(global-set-key (kbd "C-c n") 'clean-up-buffer-or-region)

;; Shell
(global-set-key (kbd "<f2>") 'shell)

;; Align regexp
(global-set-key (kbd "<f3>") 'align-regexp)

;; Font size
(define-key global-map (kbd "C-+") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)

;; Multiple-cursors
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C-<") 'mc/mark-next-like-this)
(global-set-key (kbd "C->") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; Move between windows (windmove)
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)

;; Split window
(global-set-key (kbd "C-x <right>") 'split-window-right)
(global-set-key (kbd "C-x <down>") 'split-window-below)

;; Kill current active buffer
(global-set-key (kbd "C-c k") 'kill-this-buffer)



;; Magit
(setq magit-last-seen-setup-instructions "1.4.0")
(global-set-key (kbd "<f1>") 'magit-status)

;; Smartparens
(smartparens-global-mode t)
(require 'smartparens-config)

;; Flex isearch
(global-set-key (kbd "C-M-s") #'flx-isearch-forward)
(global-set-key (kbd "C-M-r") #'flx-isearch-backward)

;; Avy
(avy-setup-default)
(global-set-key (kbd "C-'") 'avy-goto-char-2)
(global-set-key (kbd "M-g f") 'avy-goto-line)
(global-set-key (kbd "M-g w") 'avy-goto-word-1)

;; Projectile
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)

;; HELM
;; (require 'helm-projectile)

(setq helm-buffers-fuzzy-matching t)
(helm-mode 1)

(define-key helm-find-files-map (kbd "C-c C-k") 'helm-find-files-up-one-level)

(defun helm-project-files ()
  (interactive)
  (helm-other-buffer '(helm-c-source-projectile-files-list) "*Project Files*"))

(diminish 'helm-mode)

;; IDO
;; (ido-mode 1)
;; (ido-vertical-mode 1)
;; (ido-everywhere)
;; (setq ido-enable-flex-matching t)
;; (setq ido-use-faces nil)

;; (global-set-key (kbd "C-x o") 'ido-select-window)

;; Flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)

;; Auto Complete
(add-hook 'after-init-hook 'global-company-mode)

(eval-after-load "company"
  '(progn
     (setq company-idle-delay 0)
     (define-key company-active-map (kbd "TAB") (lambda () (interactive) (company-complete-common-or-cycle 1)))
     (define-key company-active-map [tab] (lambda () (interactive) (company-complete-common-or-cycle 1)))
     (define-key company-active-map (kbd "<backtab>") (lambda () (interactive) (company-complete-common-or-cycle -1)))
     (define-key company-active-map [<backtab>] (lambda () (interactive) (company-complete-common-or-cycle -1)))
     ))

;; JAVASCRIPT
(add-hook 'js-mode-hook
          (lambda ()
            (add-to-list 'company-backends 'company-tern)))

;; PYTHON
(elpy-enable)
(add-hook 'python-mode-hook
          (lambda ()
            (jedi:setup)
            (elpy-mode)))

(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; PHP
(add-hook 'php-mode-hook
          (lambda ()
            (ggtags-mode 1)
            (add-to-list 'company-backends 'company-gtags)))


;; YASNIPPETS
(yas-global-mode 1)

;; Add yasnippet support for all company backends
;; https://github.com/syl20bnr/spacemacs/pull/179
(defvar company-mode/enable-yas t
  "Enable yasnippet for all backends.")

(defun company-mode/backend-with-yas (backend)
  (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
      backend
    (append (if (consp backend) backend (list backend))
            '(:with company-yasnippet))))

(setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))

;; Enable org export to odt (OpenDocument Text)
;; It is disabled by default in org 8.x
(eval-after-load "org"
  '(require 'ox-odt nil t))
