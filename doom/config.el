;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "martynas"
      user-mail-address "martynaskvietelaitis@icloud.com")

(setenv "PATH" (concat "/Library/TeX/texbin:" (getenv "PATH")))
(setq exec-path (append '("/Library/TeX/texbin") exec-path))


;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

(defvar my/org-agenda-current-folder nil
  "Currently selected Org Agenda folder alias.")

(defvar my/org-agenda-folders-alist
  '(("f2025" . "~/Documents/notes/f2025")
    ("personal"    . "~/Documents/notes/personal"))
  "Alist mapping user-friendly names to Org Agenda folder paths.")

;;(defun my/prompt-org-agenda-folder (&rest _)
;;  "Prompt user to select a folder alias and set `org-agenda-files`."
;;  (let* ((choice (completing-read "Choose Org Agenda Folder: " (mapcar #'car my/org-agenda-folders-alist) nil t))
;;         (path   (cdr (assoc choice my/org-agenda-folders-alist))))
;;    (when path
;;      (setq org-agenda-files (directory-files-recursively path "\\.org$"))
;;     (message "Org Agenda files set from: %s" path))));;

(defun my/prompt-org-agenda-folder (&rest _)
  "Prompt user to select a folder alias and set `org-agenda-files`."
  (let* ((choice (completing-read "Choose Org Agenda Folder: " (mapcar #'car my/org-agenda-folders-alist) nil t))
         (path   (cdr (assoc choice my/org-agenda-folders-alist))))
    (when path
      (setq my/org-agenda-current-folder choice)
      (setq org-agenda-files (directory-files-recursively path "\\.org$"))
      (message "Org Agenda files set from: %s" path))))

;;(defun my/org-agenda-custom-prefix ()
;;  "Return COURSE and ROOM if the current agenda folder is 'f2025'."
;;  (if (string= my/org-agenda-current-folder "f2025")
;;      (format "%s | %s | "
;;              (or (org-entry-get (point) "COURSE") "")
;;              (or (org-entry-get (point) "

(defun my/org-agenda-custom-prefix ()
  "Return COURSE and ROOM if in 'f2025' folder and entry is scheduled (not a deadline)."
  (if (and (string= my/org-agenda-current-folder "f2025")
           (org-get-scheduled-time (point)))  ;; Check if scheduled
      (format "%s | %s | "
              (or (org-entry-get (point) "COURSE") "")
              (or (org-entry-get (point) "ROOM") ""))
    (format " %s | "
              (or (org-entry-get (point) "COURSE") ""))))  ;; Else branch: return empty string


(advice-add 'org-agenda :before #'my/prompt-org-agenda-folder)

(setq org-use-property-inheritance t)

(setq org-agenda-prefix-format
      '((agenda . "  %i %-12:c%?-12t% s %(my/org-agenda-custom-prefix)")
        (todo . "  %i %-12:c")
        (tags . "  %i %-12:c")
        (search . "  %i %-12:c")))


;;(setq org-agenda-prefix-format
;;      '((agenda . "  %i %-12:c%?-12t% s %(org-entry-get (point) \"COURSE\") | %(org-entry-get (point) \"ROOM\") | ")
;;        (todo . "  %i %-12:c")
;;        (tags . "  %i %-12:c")
;;        (search . "  %i %-12:c")))

(setq org-agenda-span 14
      org-agenda-start-on-weekday nil
      org-agenda-start-day "-3d")

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;;(setq org-directory "/Users/martynas/Documents/ktu/")
;;(setq org-roam-directory (file-truename "/Users/martynas/Documents/ktu"))

;;(setq org-agenda-files (directory-files-recursively "/Users/martynas/Documents/ktu" "\\.org$"))

;; Configure org-super-agenda to group agenda items by their top-level headline.
;;(after! org-super-agenda
;;  (org-super-agenda-mode 1)
;;  (setq org-super-agenda-groups
;;        '((:auto-outline-path t))))
;;
;;(setq org-roam-file-extensions '("org"))

;; (use-package! pangu-spacing
;;   :ensure t
;;   :config
;;   (global-pangu-spacing-mode 1))

;; (cl-defmethod org-roam-node-type ((node org-roam-node))
;;   "Return the TYPE of NODE."
;;   (condition-case nil
;;       (file-name-nondirectory
;;        (directory-file-name
;;         (file-name-directory
;;          (file-relative-name (org-roam-node-file node) org-roam-directory))))
;;     (
;;

;; Ensure org-roam-db is loaded and available
(use-package! org-roam
  :after org
  :hook (after-init . org-roam-db-autosync-enable)
  :config
  (setq org-roam-completion-everywhere t))

;; Simple org-roam configuration
(after! org-roam
  (setq org-roam-directory "~/Documents/notes/")

  (defun my/org-roam-capture-subject-path ()
    "Prompt for subject folder inside f2025/, create notes/ folder if missing, and return relative path."
    (let* ((base (expand-file-name "f2025/" org-roam-directory))
           (subject-folder (read-directory-name "Subject folder: " base nil t))
           (notes-folder (expand-file-name "notes/" subject-folder)))
      ;; Create the notes folder if it doesn't exist
      (unless (file-directory-p notes-folder)
        (make-directory notes-folder t))
      ;; Return relative path from org-roam-directory
      (file-relative-name notes-folder org-roam-directory)))

  (setq org-roam-capture-templates
        `(("u" "University hub (choose subject)" plain "%?"
           :target (file+head
                    (lambda ()
                      (concat (my/org-roam-capture-subject-path) "${slug}.org"))
                    "#+title: ${title}\n#+date: %U\n")
           :unnarrowed t)
          ("t" "Topic note (choose subject)" plain "%?"
           :target (file+head
                    (lambda ()
                      (concat (my/org-roam-capture-subject-path) "${slug}.org"))
                    "#+title: ${title}\n#+date: %U\n")
           :unnarrowed t)
          ("n" "Quick note" plain "%?"
           :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}\n#+date: %U\n")
           :unnarrowed t)
          ("p" "Personal note" plain "%?"
           :target (file+head "personal/${slug}.org"
                              "#+title: ${title}\n#+filetags: :personal:\n#+date: %U\n\n* Apžvalga\n\n* Užrašai\n\n")
           :unnarrowed t))))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(after! org
  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit))
;;(setq org-habit-show-all-today t)

;; Hook to auto-switch (optional)
;; (add-hook 'input-method-activate-hook #'my/auto-spell-language)
;; (add-hook 'input-method-deactivate-hook #'my/auto-spell-language)

;; Auto-detect language based on text content
(defun my/detect-language-and-switch-spell ()
  "Detect language based on text content and switch spell checker."
  (interactive)
  (save-excursion
    (let ((text (if (region-active-p)
                    (buffer-substring-no-properties (region-beginning) (region-end))
                  (buffer-substring-no-properties (point-min) (min (+ (point-min) 1000) (point-max))))))
      (if (string-match-p "[ĄąČčĘęĖėĮįŠšŲųŪūŽž]" text)
          (progn
            (ispell-change-dictionary "lt_LT")
            (message "Detected Lithuanian text, switched spell checker"))
        (progn
          (ispell-change-dictionary "en_US")
          (message "Detected English text, switched spell checker"))))))

;; Bind language detection - using a different key combination
(map! :leader
      :desc "Detect and switch language" "d l s" #'my/detect-language-and-switch-spell)

;; Per-file language setting
;; Add this as a file-local variable at the top of your org files:
;; -*- ispell-local-dictionary: "lt_LT" -*-
;; or at the bottom:
;; # Local Variables:
;; # ispell-local-dictionary: "lt_LT"
;; # End:
