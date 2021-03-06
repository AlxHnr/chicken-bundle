; Copyright (c) 2015 Alexander Heinrich <alxhnr@nudelpost.de>
;
; This software is provided 'as-is', without any express or implied
; warranty. In no event will the authors be held liable for any damages
; arising from the use of this software.
;
; Permission is granted to anyone to use this software for any purpose,
; including commercial applications, and to alter it and redistribute it
; freely, subject to the following restrictions:
;
;    1. The origin of this software must not be misrepresented; you must
;       not claim that you wrote the original software. If you use this
;       software in a product, an acknowledgment in the product
;       documentation would be appreciated but is not required.
;
;    2. Altered source versions must be plainly marked as such, and must
;       not be misrepresented as being the original software.
;
;    3. This notice may not be removed or altered from any source
;       distribution.

;; This file contains all syntactical extensions which are used by the
;; build system to build the project.

;; chb-module is a simplified version of chicken modules, which unifies
;; compilation units with modules. The build system will recognize this and
;; compile and link chb-modules properly. Chicken-builder's syntactical
;; extensions are available inside chb-modules.
(define-syntax chb-module
  (syntax-rules ()
    ((_ name (export1 export2 ...) body ...)
     (module name (export1 export2 ...)
       (import chicken scheme chb-syntax)
       body ...))
    ((_ name () body ...)
     (module name ()
       (import chicken scheme chb-syntax)
       body ...))))

;; This is basically the same as chb-module, but with the difference that
;; the build system will build standalone programs from such files.
(define-syntax chb-program
  (syntax-rules ()
    ((_ body ...)
     (module main ()
       (import chicken scheme chb-syntax)
       body ...))))

;; This is like chb-program, but with the difference that it will be build
;; and run as part of the test target. It also includes all necessary
;; imports and test statements to simplify testing.
(define-syntax chb-test
  (syntax-rules ()
    ((_ name body ...)
     (module main ()
       (import chicken scheme chb-syntax)
       (use test)
       (test-begin name)
       body ...
       (test-end)
       (test-exit)))))
