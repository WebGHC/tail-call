(module
  (func $fac (export "fac") (param i64) (result i64)
    (if (result i64) (i64.eqz (get_local 0))
      (then (i64.const 1))
      (else
        (i64.mul
          (get_local 0)
          (call $fac (i64.sub (get_local 0) (i64.const 1)))
        )
      )
    )
  )

  (func $fac-acc (export "fac-acc") (param i64 i64) (result i64)
    (if (result i64) (i64.eqz (get_local 0))
      (then (get_local 1))
      (else
        (call $fac-acc
          (i64.sub (get_local 0) (i64.const 1))
          (i64.mul (get_local 0) (get_local 1))
        )
      )
    )
  )

  (func $fac-ret-acc (export "fac-ret-acc") (param i64 i64) (result i64)
    (if (result i64) (i64.eqz (get_local 0))
      (then (return (get_local 1)))
      (else
        (return (call $fac-ret-acc
          (i64.sub (get_local 0) (i64.const 1))
          (i64.mul (get_local 0) (get_local 1))
        ))
      )
    )
  )

  (func $fac-tail (export "fac-tail") (param $x i64) (result i64)
    (return_call $fac-tail-aux (get_local $x) (i64.const 1))
  )

  (func $fac-tail-aux (tail_call) (param $x i64) (param $r i64) (result i64)
    (if (result i64) (i64.eqz (get_local $x))
      (then (return (get_local $r)))
      (else
        (return_call $fac-tail-aux
          (i64.sub (get_local $x) (i64.const 1))
          (i64.mul (get_local $x) (get_local $r))
        )
      )
    )
  )
)

  (invoke "fac" (i64.const 4))
  (assert_exhaustion (invoke "fac" (i64.const 300)) "call stack exhausted")

  (invoke "fac-acc" (i64.const 4) (i64.const 1))
  (assert_exhaustion (invoke "fac-acc" (i64.const 300) (i64.const 1)) "call stack exhausted")

  (invoke "fac-ret-acc" (i64.const 4) (i64.const 1))
  (assert_exhaustion (invoke "fac-ret-acc" (i64.const 300) (i64.const 1)) "call stack exhausted")

  (invoke "fac-tail" (i64.const 4))
  (invoke "fac-tail" (i64.const 300))


