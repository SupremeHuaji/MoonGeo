// MoonGeo - 工具函数

// ==================== 基本数学运算 ====================

///|
/// 计算平方
pub fn square(x : Double) -> Double {
  x * x
}

///|
/// 计算立方
pub fn cube(x : Double) -> Double {
  x * x * x
}

///|
/// 计算绝对值
pub fn abs(x : Double) -> Double {
  if x < 0.0 {
    -x
  } else {
    x
  }
}

///|
/// 计算最大值
pub fn max(a : Double, b : Double) -> Double {
  if a > b {
    a
  } else {
    b
  }
}

///|
/// 计算最小值
pub fn min(a : Double, b : Double) -> Double {
  if a < b {
    a
  } else {
    b
  }
}

///|
/// 安全除法，分母为零时返回默认值
pub fn safe_div(num : Double, den : Double, fallback : Double) -> Double {
  if abs(den) <= EPSILON {
    fallback
  } else {
    num / den
  }
}

///|
/// 判断两个浮点数是否近似相等
pub fn approx_equal(a : Double, b : Double, tolerance : Double) -> Bool {
  abs(a - b) < tolerance
}

///|
/// 限制值在范围内
pub fn clamp(value : Double, min_val : Double, max_val : Double) -> Double {
  if value < min_val {
    min_val
  } else if value > max_val {
    max_val
  } else {
    value
  }
}

// ==================== 三角函数 ====================

///|
/// 角度转弧度
pub fn deg_to_rad(deg : Double) -> Double {
  deg * PI / 180.0
}

///|
/// 弧度转角度
pub fn rad_to_deg(rad : Double) -> Double {
  rad * 180.0 / PI
}

///|
/// 正弦函数近似 (泰勒级数)
pub fn sin_approx(x : Double) -> Double {
  let mut a = x
  while a > PI {
    a = a - 2.0 * PI
  }
  while a < -PI {
    a = a + 2.0 * PI
  }
  let x2 = a * a
  let x3 = x2 * a
  let x5 = x3 * x2
  let x7 = x5 * x2
  a - x3 / 6.0 + x5 / 120.0 - x7 / 5040.0
}

///|
/// 余弦函数近似 (泰勒级数)
pub fn cos_approx(x : Double) -> Double {
  let mut a = x
  while a > PI {
    a = a - 2.0 * PI
  }
  while a < -PI {
    a = a + 2.0 * PI
  }
  let x2 = a * a
  let x4 = x2 * x2
  let x6 = x4 * x2
  1.0 - x2 / 2.0 + x4 / 24.0 - x6 / 720.0
}

///|
/// 正切函数近似
pub fn tan_approx(x : Double) -> Double {
  let sin_x = sin_approx(x)
  let cos_x = cos_approx(x)
  if abs(cos_x) < EPSILON {
    0.0
  } else {
    sin_x / cos_x
  }
}

///|
/// 自然对数近似
pub fn ln_approx(x : Double) -> Double {
  if x <= 0.0 {
    return 0.0
  }
  if x == 1.0 {
    return 0.0
  }
  if x > 1.0 {
    return -ln_approx(1.0 / x)
  }
  let u = x - 1.0
  let mut sum = u
  let mut term = u
  let mut i = 2
  while i < 50 {
    term = term * -u
    sum = sum + term / i.to_double()
    if abs(term) < EPSILON {
      break
    }
    i = i + 1
  }
  sum
}

///|
/// 指数函数近似 (e^x)
pub fn exp_approx(x : Double) -> Double {
  if x > 10.0 {
    return 0.0 // 溢出
  }
  if x < -10.0 {
    return 0.0
  }
  let mut sum = 1.0
  let mut term = 1.0
  let mut i = 1
  while i < 20 {
    term = term * x / i.to_double()
    sum = sum + term
    if abs(term) < EPSILON {
      break
    }
    i = i + 1
  }
  sum
}
