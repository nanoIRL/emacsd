;; -*- lexical-binding: t; -*-

;; Disable GC during startup; restored below.  Keep file-name handlers
;; enabled: init reads encrypted auth-source files through `epa-file'.
(setq gc-cons-threshold most-positive-fixnum)
(defun my/restore-startup-defaults ()
  ;; Must stay idempotent: it runs from both the hook and the timer.
  (setq gc-cons-threshold (* 32 1024 1024)))
(add-hook 'emacs-startup-hook #'my/restore-startup-defaults 90)
(run-with-timer 10 nil #'my/restore-startup-defaults)

(setq package-enable-at-startup nil)
(with-eval-after-load 'use-package-core
  (eval-after-load 'lisp-mode
    `(let ((symbol-regexp
            (or (bound-and-true-p lisp-mode-symbol-regexp)
                "\\(?:\\sw\\|\\s_\\|\\\\.\\)+")))
       (add-to-list 'lisp-imenu-generic-expression
                    (list "Packages" ,use-package-form-regexp-eval 2))
       (add-to-list 'lisp-imenu-generic-expression
                    (list "Packages"
                          (concat "^\\s-*(use-package-full\\s-+\\("
                                  symbol-regexp
                                  "\\)")
                          1)))))
(setq use-package-enable-imenu-support t)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(setq initial-frame-alist '(
                            ;; (fullscreen . fullboth)
                            (vertical-scroll-bars . nil)))
(setq default-frame-alist '((vertical-scroll-bars . nil)
                            ;; (width . 80) ;; default
                            ;; (height . 36) ;; default
                            (width . 120)
                            (height . 54)))
(unless (display-graphic-p)
  (setq frame-background-mode 'light))
