;; NOTE: Assertions have been generated by update_lit_checks.py --output=fuzz-exec and should not be edited.

;; RUN: wasm-opt %s -all --fuzz-exec -q -o /dev/null 2>&1 | filecheck %s

(module
  ;; CHECK:      [fuzz-exec] calling null-local
  ;; CHECK-NEXT: [fuzz-exec] note result: null-local => 1
  (func "null-local" (result i32)
    (local $ref (ref null i31))
    (ref.is_null
      (local.get $ref)
    )
  )

  ;; CHECK:      [fuzz-exec] calling null-immediate
  ;; CHECK-NEXT: [fuzz-exec] note result: null-immediate => 1
  (func "null-immediate" (result i32)
    (ref.is_null
      (ref.null i31)
    )
  )

  ;; CHECK:      [fuzz-exec] calling non-null
  ;; CHECK-NEXT: [fuzz-exec] note result: non-null => 0
  (func "non-null" (result i32)
    (ref.is_null
      (ref.i31
        (i32.const 1234)
      )
    )
  )

  ;; CHECK:      [fuzz-exec] calling nn-u
  ;; CHECK-NEXT: [fuzz-exec] note result: nn-u => 2147483647
  (func "nn-u" (result i32)
    (i31.get_u
      (ref.i31
        (i32.const 0xffffffff)
      )
    )
  )

  ;; CHECK:      [fuzz-exec] calling nn-s
  ;; CHECK-NEXT: [fuzz-exec] note result: nn-s => -1
  (func "nn-s" (result i32)
    (i31.get_s
      (ref.i31
        (i32.const 0xffffffff)
      )
    )
  )

  ;; CHECK:      [fuzz-exec] calling zero-is-not-null
  ;; CHECK-NEXT: [fuzz-exec] note result: zero-is-not-null => 0
  (func "zero-is-not-null" (result i32)
    (local $ref (ref null i31))
    (local.set $ref
      (ref.i31
        (i32.const 0)
      )
    )
    (i32.add ;; 0 + 0 is 0
      (ref.is_null
        (local.get $ref)
      )
      (i31.get_u ;; this should not trap on null
        (local.get $ref)
      )
    )
  )

  ;; CHECK:      [fuzz-exec] calling trap
  ;; CHECK-NEXT: [trap null ref]
  (func "trap" (result i32)
    (i31.get_u
      (ref.null i31)
    )
  )
)
;; CHECK:      [fuzz-exec] calling null-local
;; CHECK-NEXT: [fuzz-exec] note result: null-local => 1

;; CHECK:      [fuzz-exec] calling null-immediate
;; CHECK-NEXT: [fuzz-exec] note result: null-immediate => 1

;; CHECK:      [fuzz-exec] calling non-null
;; CHECK-NEXT: [fuzz-exec] note result: non-null => 0

;; CHECK:      [fuzz-exec] calling nn-u
;; CHECK-NEXT: [fuzz-exec] note result: nn-u => 2147483647

;; CHECK:      [fuzz-exec] calling nn-s
;; CHECK-NEXT: [fuzz-exec] note result: nn-s => -1

;; CHECK:      [fuzz-exec] calling zero-is-not-null
;; CHECK-NEXT: [fuzz-exec] note result: zero-is-not-null => 0

;; CHECK:      [fuzz-exec] calling trap
;; CHECK-NEXT: [trap null ref]
;; CHECK-NEXT: [fuzz-exec] comparing nn-s
;; CHECK-NEXT: [fuzz-exec] comparing nn-u
;; CHECK-NEXT: [fuzz-exec] comparing non-null
;; CHECK-NEXT: [fuzz-exec] comparing null-immediate
;; CHECK-NEXT: [fuzz-exec] comparing null-local
;; CHECK-NEXT: [fuzz-exec] comparing trap
;; CHECK-NEXT: [fuzz-exec] comparing zero-is-not-null
