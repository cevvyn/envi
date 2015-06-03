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
(load-theme 'material t)

;; OSX Custom settings
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))

;; Do not show startup message
(setq inhibit-startup-message t)

;; Keep emacs Custom-settings in separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; Appearance
(setq-default line-spacing 10)
(setq-default cursor-type 'bar)
(setq-default cursor-in-non-selected-windows 'hbar)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; Avy
(avy-setup-default)
(global-set-key (kbd "C-'") 'avy-goto-char-2)
(global-set-key (kbd "M-g f") 'avy-goto-line)
(global-set-key (kbd "M-g w") 'avy-goto-word-1)
		
;; IDO
(ido-mode 1)
(ido-vertical-mode 1)
(ido-everywhere)

(global-set-key (kbd "C-x o") 'ido-select-window)

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
     (add-to-list 'company-backends 'company-tern)
     ))

;; Ace Jump Mode
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)

;; Projectile
(projectile-global-mode)

;; Enable org export to odt (OpenDocument Text)
;; It is disabled by default in org 8.x
(eval-after-load "org"
  '(require 'ox-odt nil t))
