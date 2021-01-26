(defun css-tidy ()
    (interactive)
    (shell-command-on-region (point-min) (point-max) "/home/ben/projects/css-tidy/script/csstidy" (current-buffer) t)
)

