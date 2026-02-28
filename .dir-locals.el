;;; Directory Local Variables            -*- no-byte-compile: t -*-

((org-mode
  . ((eval
      . (org-link-set-parameters
         "sc"
         :export (lambda (path _desc backend _info)
                   (pcase backend
                     ('html (format "<span class=\"smallcaps\">%s</span>" path))
                     ('latex (format "\\textsc{%s}" (string-replace "&" "\\&" path)))
                     (_ path))))))))
