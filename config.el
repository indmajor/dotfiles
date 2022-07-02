;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Olga Andreeeva"
      user-mail-address "olga.andreeva@protonmail.com")

(setq doom-theme 'doom-one)

(setq display-line-numbers-type t
      evil-want-fine-undo t)

(setq org-directory "~/Dropbox/org/")

(display-battery-mode 1)
(global-subword-mode 1) ; Iterate through CamelCase

(after! ispell
  (with-eval-after-load "ispell"
    ;; Configure `LANG`, otherwise ispell.el cannot find a 'default
    ;; dictionary' even though multiple dictionaries will be configured
    ;; in next line.
    (setenv "LANG" "en_US,de_DE,ru_RU")
    (setq ispell-really-hunspell t)
    (setq ispell-program-name (executable-find "hunspell"))
    ;; Configure German, English and Russian
    ;;(setq ispell-dictionary "de_DE,en_US,ru_RU")
    ;;(setq ispell-dictionary-alist "de_DE,en_US,ru_RU")
    (setq ispell-local-dictionary-alist '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "de_DE,en_US,ru_RU") nil utf-8)))
    ;; ispell-set-spellchecker-params has to be called
    (ispell-set-spellchecker-params)
    ;; before ispell-hunspell-add-multi-dic will work
    (ispell-hunspell-add-multi-dic "de_DE,en_US,ru_RU")
    ;; For saving words to the personal dictionary, don't infer it from
    ;; the locale, otherwise it would save to ~/.hunspell_de_DE.
    (setq ispell-personal-dictionary "~/.doom.d/personal_dict")))

(setq inferior-STA-program-name "/opt/homebrew/bin/jupyter-console")
(setq inferior-STA-start-args "--simple-prompt --kernel=stata")

(use-package! ado-mode)

(use-package ob-jupyter
  :ensure t
  :config
         (defun org-babel-execute:ado (body params)
           (org-babel-execute:jupyter-stata body params))
         (setq org-babel-default-header-args:ado
               `((:session . "stata")
                 (:kernel . "stata")))
  )


(setq cdlatex-env-alist
     '(("equation*" "\\begin{equation*}\n?\n\\end{equation*}\n" nil)))
(setq cdlatex-math-modify-alist
      '((?s "\\mathbb" nil t nil nil)
        (?m "\\texttt" nil t nil nil)
        (?t "\\text" nil t nil nil)))
(setq cdlatex-math-symbol-alist
'((?. ("\\cdot" "\\dots" nil nil))
  (?. ("\\cdot" "\\dots" nil nil))
  (?~ ("\\sim" "\\approx" "\\sim"))))

(after! org
  (define-key org-mode-map (kbd "s-i")
    (lambda () (interactive) (org-emphasize ?\/)))
  (define-key org-mode-map (kbd "s-b")
    (lambda () (interactive) (org-emphasize ?\*)))
  (setq org-M-RET-may-split-line t))

(defun my-org-latex-yas ()
  "Activate org and LaTeX yas expansion in org-mode buffers."
  (yas-minor-mode)
  (yas-activate-extra-mode 'latex-mode))

(add-hook 'org-mode-hook #'my-org-latex-yas)
(add-hook 'org-mode-hook 'org-fragtog-mode)

(sp-pair "\\\(" "\\\)" :trigger "dd")
(sp-pair "\\\left(" " \\right)" :trigger "lrc")
(sp-pair "\\\left[" " \\right]" :trigger "lrs")

(after! evil-surround
  (let ((pairs '((?m "\\\(" . "\\\) "))))
    (prependq! evil-surround-pairs-alist pairs)
    (prependq! evil-embrace-evil-surround-keys (mapcar #'car pairs))))

(setq org-books-file "~/Dropbox/org/books.org")
(setq org-anki-file "~/Dropbox/org/anki.org")
(after! org
  (add-to-list 'org-capture-templates '("a" "Anki" entry (file org-anki-file)
               "* Item
%^{ANKI_NOTE_TYPE}p %^{ANKI_DECK}p
** Front
%?
** Back
%x" :empty-lines 1)))

(use-package! org-ref)

(setq! citar-bibliography '("~/Dropbox/org/library.bib"))

(setq evil-vsplit-window-right t
      evil-split-window-below t)
(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (consult-buffer))

(setq +latex-viewers '(pdf-tools))
