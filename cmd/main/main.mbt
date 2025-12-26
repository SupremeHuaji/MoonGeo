///|
fn main {
  // 示例：计算朗肯主动土压力
  // φ=30°, γ=18kN/m³, H=5m
  let ka = @lib.rankine_active_coefficient(30.0)
  let ea = @lib.rankine_active_force(ka, 18.0, 5.0)
  println("朗肯主动土压力系数: \{ka}")
  println("主动土压力合力: \{ea} kN/m")

  // 示例：计算太沙基承载力
  let qu = @lib.terzaghi_bearing_capacity(10.0, 20.0, 18.0, 2.0, 30.0)
  println("太沙基极限承载力: \{qu} kPa")

  // 示例：计算固结度
  let u = @lib.consolidation_degree(0.5)
  println("固结度: \{u * 100.0}%")
}
