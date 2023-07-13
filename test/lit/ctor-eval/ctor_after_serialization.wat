;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: foreach %s %t wasm-ctor-eval --ctors=new,nop --kept-exports=new,nop --quiet -all -S -o - | filecheck %s

;; We can eval $new, and afterwards also eval $nop as well. When doing the
;; latter we should not undo or break the previous work in any way. In
;; particular, we should have a valid global for $new to refer to (which
;; contains the serialization of the struct.new instruction).

(module
 ;; CHECK:      (type $A (struct ))
 (type $A (struct))

 ;; CHECK:      (type $1 (func (result (ref any))))

 ;; CHECK:      (type $2 (func))

 ;; CHECK:      (global $ctor-eval$global (ref $A) (struct.new_default $A))

 ;; CHECK:      (export "new" (func $new_2))
 (export "new" (func $new))
 ;; CHECK:      (export "nop" (func $nop_3))
 (export "nop" (func $nop))

 (func $new (result (ref any))
  (struct.new $A)
 )

 (func $nop
  (nop)
 )
)

;; CHECK:      (func $new_2 (type $1) (result (ref any))
;; CHECK-NEXT:  (global.get $ctor-eval$global)
;; CHECK-NEXT: )

;; CHECK:      (func $nop_3 (type $2)
;; CHECK-NEXT:  (nop)
;; CHECK-NEXT: )
(module
 ;; As above, but now there is an existing global with the name that we want to
 ;; use. We should not collide.

 ;; CHECK:      (type $A (struct ))
 (type $A (struct))

 ;; CHECK:      (type $1 (func (result (ref any))))

 ;; CHECK:      (type $2 (func (result anyref)))

 ;; CHECK:      (global $ctor-eval$global (ref $A) (struct.new_default $A))
 (global $ctor-eval$global (ref $A)
  (struct.new_default $A)
 )

 ;; CHECK:      (global $ctor-eval$global_1 (ref $A) (struct.new_default $A))

 ;; CHECK:      (export "new" (func $new_2))
 (export "new" (func $new))
 ;; CHECK:      (export "nop" (func $nop_3))
 (export "nop" (func $nop))

 (func $new (result (ref any))
  (struct.new $A)
 )

 (func $nop (result anyref)
  ;; Use the existing global to keep it alive.
  (global.get $ctor-eval$global)
 )
)
;; CHECK:      (func $new_2 (type $1) (result (ref any))
;; CHECK-NEXT:  (global.get $ctor-eval$global_1)
;; CHECK-NEXT: )

;; CHECK:      (func $nop_3 (type $2) (result anyref)
;; CHECK-NEXT:  (global.get $ctor-eval$global)
;; CHECK-NEXT: )
