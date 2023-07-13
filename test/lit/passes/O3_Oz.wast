;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: foreach %s %t wasm-opt -O3 -Oz -S -o - | filecheck %s

(module
  (func $inline.me (param $x i32) (result i32)
    (i32.add
      (local.get $x)
      (i32.const 2)
    )
  )

  (func "export" (param $x i32) (result i32)
    ;; $inline.me is called twice, so we do not always inline it like called-
    ;; once functions are. -Oz is too cautious to inline such things that may
    ;; end up increasing total code size, but we are running -O3 -Oz here and so
    ;; the first -O3 will inline there. That is, this test verifies that the
    ;; later -Oz does not affect the earlier -O3 (which it could, if -Oz set
    ;; global state that -O3 then reads to see the optimization and shrink
    ;; levels).
    (i32.add
      (call $inline.me
        (local.get $x)
      )
      (call $inline.me
        (local.get $x)
      )
    )
  )
)
;; CHECK:      (type $0 (func (param i32) (result i32)))

;; CHECK:      (export "export" (func $1))

;; CHECK:      (func $1 (; has Stack IR ;) (param $0 i32) (result i32)
;; CHECK-NEXT:  (i32.add
;; CHECK-NEXT:   (local.tee $0
;; CHECK-NEXT:    (i32.add
;; CHECK-NEXT:     (local.get $0)
;; CHECK-NEXT:     (i32.const 2)
;; CHECK-NEXT:    )
;; CHECK-NEXT:   )
;; CHECK-NEXT:   (local.get $0)
;; CHECK-NEXT:  )
;; CHECK-NEXT: )
