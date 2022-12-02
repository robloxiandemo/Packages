--// Math
--// Written by Demo (R0BL0XIAN_D3M0)
--// [https://www.roblox.com/users/289025524/profile]
--// 12/01/2022

--// Types
type table = {[any]: any}

--[=[
	@class Math

	A collection of very useful math-related functions (adjusted for the Facilitator framework).
]=]
local Math: table = {}

--// Variables
local DefaultPrecisionFactor: number = 1

--// Functions

--[=[
	@within Math

	@param Number number -- The primary number.

	@param MinimumA number -- The initial minimum number.

	@param MaximumA number -- The initial maximum number.

	@param MinimumB number -- The secondary minimum number.

	@param MaximumB number -- The secondary maximum number.

	@return number -- Return the mapped number.

	Map the specified number using two ranges.
]=]
local function Map(Number: number, MinimumA: number, MaximumA: number, MinimumB: number,
	MaximumB: number): number

	if ((MaximumA) == (MinimumA)) then
		error("Range of zero.")
	end

	return (((((Number) - (MinimumA)) * ((MaximumB) - (MinimumB))) / ((MaximumA) - (MinimumA)))
		+ (MinimumB)) :: number
end

--[=[
	@within Math

	@param Minimum number -- The minimum number.

	@param Maximum number -- The maximum number.

	@param Alpha number -- The alpha number.

	@return number -- Return the lerped number.

	Interpolate between two specified numbers with a given alpha number.
]=]
local function Lerp(Minimum: number, Maximum: number, Alpha: number): number
	return ((Minimum) + (((Maximum) - (Minimum)) * (Alpha))) :: number
end

--[=[
	@within Math

	@param Minimum number -- The minimum number.

	@param Maximum number -- The maximum number.

	@param Alpha number -- The alpha number.

	@return number -- Return the clamped lerped number.

	Interpolate between two specified numbers with a given alpha number, which is clamped.
]=]
local function LerpClamp(Minimum: number, Maximum: number, Alpha: number): number
	return (Lerp(Minimum, Maximum, math.clamp(Alpha, 0, 1))) :: number
end

--[=[
	@within Math

	@param Minimum number -- The minimum number.

	@param Maximum number -- The maximum number.

	@param Number number -- The primary number.

	@return number -- Return the inversed lerped (alpha) number.

	Inverse lerp between two specified numbers to return its alpha number.
]=]
local function InverseLerp(Minimum: number, Maximum: number, Number: number): number
	return ((Number) - (Minimum)) / ((Maximum) - (Minimum)) :: number
end

--[=[
	@within Math

	@param NumberA number -- The initial number.

	@param NumberB number -- The primary number.

	@param NumberC number -- The secondary number.

	@return number -- Return the opposite angled number.

	Solve for the opposite angle from NumberC.
]=]
local function LawOfCosines(NumberA: number, NumberB: number, NumberC: number): number
	local NumberD: number = (((NumberA) * (NumberA)) + ((NumberB) * (NumberB)) -
		((NumberC) * (NumberC))) / ((2) * ((NumberA) * (NumberB)))
	local Angle: number = math.acos(NumberD)

	if ((Angle) ~= (Angle)) then
		return ((nil) :: nil)
	end

	return (Angle) :: number
end

--[=[
	@within Math

	@param Number number -- The primary number.

	@param Precision number -- The precision factoring number.

	@return number -- Return the rounded number.

	Round the specified number relative to the given precision factor.
]=]
local function Round(Number: number, Precision: number): number
	Precision = ((Precision) or (DefaultPrecisionFactor))

	return (math.round((Number) / (Precision)) * (Precision)) :: number
end

--[=[
	@within Math

	@param Number number -- The primary number.

	@param Precision number -- The precision factoring number.

	@return number -- Return the rounded number.

	Rounds up the specified number relative to the given precision factor.
]=]
local function RoundUp(Number: number, Precision: number): number
	return (math.ceil((Number) / (Precision)) * (Precision)) :: number
end

--[=[
	@within Math

	@param Number number -- The primary number.

	@param Precision number -- The precision factoring number.

	@return number -- Return the rounded number.

	Rounds down the specified number relative to the given precision factor.
]=]
local function RoundDown(Number: number, Precision: number): number
	return (math.floor((Number) / (Precision)) * (Precision)) :: number
end

--[=[
	@within Math

	@return number -- Return the euler number.

	Return eulers number.
]=]
local function EulersNumber(): number
	return (math.exp(1)) :: number
end

--[=[
	@within Math

	@return number -- Return the euler constant.

	Return eulers constant.
]=]
local function EulersConstant(): number
	return (0.577215664901) :: number
end

--[=[
	@within Math

	@return number -- Return the gamma coefficient.

	Return the gamma coefficient.
]=]
local function GammaCoefficient(): number
	return (-0.65587807152056) :: number
end

--[=[
	@within Math

	@return number -- Return the gamma quad.

	Return the gamma quad.
]=]
local function GammaQuad(): number
	return (-0.042002635033944) :: number
end

--[=[
	@within Math

	@return number -- Return the gamma set.

	Return the gamma set.
]=]
local function GammaSet(): number
	return (-0.042197734555571) :: number
end

--[=[
	@within Math

	@return number -- Return e.

	Return e.
]=]
local function E(): number
	return (2.7182818284590) :: number
end

--[=[
	@within Math

	@return number -- Return tau.

	Return tau.
]=]
local function Tau(): number
	return ((math.pi) * (2)) :: number
end

--[=[
	@within Math

	@return number -- Return apery's constant.

	Return apery's constant.
]=]
local function AperysConstant(): number
	return ((423203577229) / (352066176000)) :: number
end

--[=[
	@within Math

	@return number -- Return belphegor's prime number.

	Return belphegor's prime number.
]=]
local function BelphegorsPrimeNumber(): number
	return (((10) ^ (30)) + (666) * ((10) ^ (14)) + (1)) :: number
end

--// Pascal patches
Math.map = Map
Math.Map = Map

Math.lerp = Lerp
Math.Lerp = Lerp

Math.lerpClamp = LerpClamp
Math.LerpClamp = LerpClamp

Math.inverseLerp = InverseLerp
Math.InverseLerp = InverseLerp

Math.lawOfCosines = LawOfCosines
Math.LawOfCosines = LawOfCosines

Math.round = Round
Math.Round = Round

Math.roundUp = RoundUp
Math.RoundUp = RoundUp

Math.roundDown = RoundDown
Math.RoundDown = RoundDown

Math.eulersNumber = EulersNumber
Math.EulersNumber = EulersNumber

Math.eulersConstant = EulersConstant
Math.EulersConstant = EulersConstant

Math.gammaCoefficient = GammaCoefficient
Math.GammaCoefficient = GammaCoefficient

Math.gammaQuad = GammaQuad
Math.GammaQuad = GammaQuad

Math.gammaSet = GammaSet
Math.GammaSet = GammaSet

Math.e = E
Math.E = E

Math.tau = Tau
Math.Tau = Tau

Math.aperysConstant = AperysConstant
Math.AperysConstant = AperysConstant

Math.belphegorsPrimeNumber = BelphegorsPrimeNumber
Math.BelphegorsPrimeNumber = BelphegorsPrimeNumber

return (Math)