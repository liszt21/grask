(define-module (grask)
 #:use-module (gnu packages wm)
 #:use-module (gnu packages haskell-xyz)
 #:use-module (gnu packages xorg)
 #:use-module (guix gexp)
 #:use-module (guix git-download)
 #:use-module (guix packages)
 #:use-module (guix utils)
 #:use-module (ice-9 popen)
 #:use-module (ice-9 rdelim)
 #:use-module (ice-9 regex))

(define %local
  (local-file (string-append (dirname (current-filename)) "/config/xmonad")
              #:recursive? #t
              #:select?
              (lambda (f _)
                (not
                 (or (string-match "\\.ghc\\.environment" f)
                     (string-match "dist" f)
                     (string-match "dist-newstyle" f))))))

(define-public grask-xmonad
  (package
    (inherit xmonad)
    (name "grask-xmonad")
    (version "0.0.0")
    (source %local)
    (inputs
     `(("libxpm" ,libxpm)
       ("xmobar" ,xmobar)
       ("xmonad" ,xmonad)
       ("ghc-random" ,ghc-random)
       ("ghc-uuid" ,ghc-uuid)
       ("ghc-xmonad-contrib" ,ghc-xmonad-contrib)))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'install 'make-static
           (lambda* (#:key outputs #:allow-other-keys)
             (mkdir-p (assoc-ref outputs "static"))))
         (delete 'install-license-files))))))