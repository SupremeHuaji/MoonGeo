// MoonGeo - 土力学/岩土工程常量定义

// ==================== 数学常量 ====================

///|
/// 圆周率
pub const PI : Double = 3.141592653589793

///|
/// 浮点数比较精度
pub const EPSILON : Double = 1.0e-10

// ==================== 物理常量 ====================

///|
/// 标准重力加速度 (m/s²)
pub const G : Double = 9.80665

///|
/// 水的密度 (kg/m³)
pub const RHO_WATER : Double = 1000.0

///|
/// 水的容重 (kN/m³)
pub const GAMMA_WATER : Double = 9.81

// ==================== 土的物理性质 ====================

///|
/// 粘性土容重 (kN/m³) - 一般值
pub const GAMMA_CLAY : Double = 18.0

///|
/// 砂土容重 (kN/m³) - 一般值
pub const GAMMA_SAND : Double = 19.0

///|
/// 饱和土容重 (kN/m³) - 一般值
pub const GAMMA_SAT : Double = 20.0

///|
/// 浮容重 (kN/m³) - 一般值
pub const GAMMA_SUB : Double = 10.0

// ==================== 土的强度参数 ====================

///|
/// 粘性土内摩擦角 (度) - 软粘土
pub const PHI_SOFT_CLAY : Double = 0.0

///|
/// 粘性土内摩擦角 (度) - 一般粘土
pub const PHI_CLAY : Double = 15.0

///|
/// 粘性土内摩擦角 (度) - 硬粘土
pub const PHI_HARD_CLAY : Double = 25.0

///|
/// 砂土内摩擦角 (度) - 松砂
pub const PHI_LOOSE_SAND : Double = 30.0

///|
/// 砂土内摩擦角 (度) - 中密砂
pub const PHI_MEDIUM_SAND : Double = 35.0

///|
/// 砂土内摩擦角 (度) - 密砂
pub const PHI_DENSE_SAND : Double = 40.0

///|
/// 粘聚力 (kPa) - 软粘土
pub const C_SOFT_CLAY : Double = 10.0

///|
/// 粘聚力 (kPa) - 一般粘土
pub const C_CLAY : Double = 30.0

///|
/// 粘聚力 (kPa) - 硬粘土
pub const C_HARD_CLAY : Double = 50.0

// ==================== 渗透系数 ====================

///|
/// 渗透系数 (m/s) - 粘土
pub const K_CLAY : Double = 1.0e-9

///|
/// 渗透系数 (m/s) - 粉土
pub const K_SILT : Double = 1.0e-6

///|
/// 渗透系数 (m/s) - 细砂
pub const K_FINE_SAND : Double = 1.0e-5

///|
/// 渗透系数 (m/s) - 中砂
pub const K_MEDIUM_SAND : Double = 1.0e-4

///|
/// 渗透系数 (m/s) - 粗砂
pub const K_COARSE_SAND : Double = 1.0e-3

///|
/// 渗透系数 (m/s) - 砾石
pub const K_GRAVEL : Double = 1.0e-2

// ==================== 压缩性参数 ====================

///|
/// 压缩系数 a_v (MPa⁻¹) - 低压缩性土
pub const AV_LOW : Double = 0.1

///|
/// 压缩系数 a_v (MPa⁻¹) - 中压缩性土
pub const AV_MEDIUM : Double = 0.5

///|
/// 压缩系数 a_v (MPa⁻¹) - 高压缩性土
pub const AV_HIGH : Double = 1.0

///|
/// 压缩模量 E_s (MPa) - 低压缩性土
pub const ES_LOW : Double = 15.0

///|
/// 压缩模量 E_s (MPa) - 中压缩性土
pub const ES_MEDIUM : Double = 5.0

///|
/// 压缩模量 E_s (MPa) - 高压缩性土
pub const ES_HIGH : Double = 2.0

// ==================== 固结参数 ====================

///|
/// 固结系数 C_v (m²/s) - 粘土
pub const CV_CLAY : Double = 1.0e-8

///|
/// 固结系数 C_v (m²/s) - 粉土
pub const CV_SILT : Double = 1.0e-7

///|
/// 固结系数 C_v (m²/s) - 砂土
pub const CV_SAND : Double = 1.0e-6

// ==================== 土压力系数 ====================

///|
/// 静止土压力系数 (一般值)
pub const K0_NORMAL : Double = 0.5

///|
/// 静止土压力系数 (超固结土)
pub const K0_OVERCONSOLIDATED : Double = 1.0

// ==================== 承载力系数 ====================

///|
/// 太沙基承载力系数 N_c (φ=0)
pub const NC_PHI0 : Double = 5.7

///|
/// 太沙基承载力系数 N_q (φ=0)
pub const NQ_PHI0 : Double = 1.0

///|
/// 太沙基承载力系数 N_γ (φ=0)
pub const NGAMMA_PHI0 : Double = 0.0

// ==================== 边坡稳定 ====================

///|
/// 安全系数 - 一般要求
pub const FS_NORMAL : Double = 1.3

///|
/// 安全系数 - 重要工程
pub const FS_IMPORTANT : Double = 1.5

///|
/// 安全系数 - 临时工程
pub const FS_TEMPORARY : Double = 1.2

// ==================== 单位换算 ====================

///|
/// kPa 转 Pa
pub const KPA_TO_PA : Double = 1000.0

///|
/// MPa 转 Pa
pub const MPA_TO_PA : Double = 1000000.0

///|
/// m 转 cm
pub const M_TO_CM : Double = 100.0

///|
/// cm 转 m
pub const CM_TO_M : Double = 0.01

///|
/// 度转弧度
pub const DEG_TO_RAD : Double = 0.017453292519943295

///|
/// 弧度转度
pub const RAD_TO_DEG : Double = 57.29577951308232
