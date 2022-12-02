--// Vector
--// Written by Demo (R0BL0XIAN_D3M0)
--// [https://www.roblox.com/users/289025524/profile]
--// 12/01/2022

--// Types
type table = {[any]: any}
type Vector = Vector2 | Vector3

--[=[
	@class Vector

	A collection of very useful vector-related functions (adjusted for the Facilitator framework).
]=]
local Vector: table = {}

--// Functions

--[=[
	@within Vector

	@param Vector2 Vector2 -- The Vector2.

	@return Vector3 -- Return the newly created Vector3.

	Create a Vector3 from a Vector2 within the XY plane.
]=]
local function FromVector2XY(Vector2: Vector2): Vector3
	return (Vector3.new(Vector2.X, Vector2.Y, 0)) :: Vector3
end

--[=[
	@within Vector

	@param Vector2 Vector2 -- The Vector2.

	@return Vector3 -- Return the newly created Vector3.

	Create a Vector3 from a Vector2 within the XZ plane.
]=]
local function FromVector2XZ(Vector2: Vector2): Vector3
	return (Vector3.new(Vector2.X, 0, Vector2.Y)) :: Vector3
end

--[=[
	@within Vector

	@param VectorA Vector2 -- The initial Vector2.

	@param VectorB Vector2 -- The secondary Vector2.

	@return number -- Return the computed angle in a numerical form.

	Compute the angle between two vectors in radians.
]=]
local function GetAngleRad(VectorA: Vector2, VectorB: Vector2): number
	if ((VectorA.Magnitude) == (0)) then
		return ((nil) :: nil)
	end

	return (math.acos(VectorA:Dot(VectorB))) :: number
end

--[=[
	@within Vector

	@param VectorA Vector2 -- The initial Vector2.

	@param VectorB Vector2 -- The secondary Vector2.

	@return number -- Return the computed angle in a numerical form.

	Compute the angle between two vectors.
]=]
local function AngleBetweenVectors(VectorA: Vector2, VectorB: Vector2): number
	local ValueA: Vector2 = (VectorB.Magnitude * VectorA)
	local ValueB: Vector2 = (VectorA.Magnitude * VectorB)

	return ((2) * (math.atan2(((ValueB) - (ValueA)).Magnitude, ((ValueA) + (ValueB)).Magnitude)))
		:: number
end

--[=[
	@within Vector

	@param VectorA Vector3 -- The Vector3.

	@param Amount number -- The primary amount.

	@return Vector3 -- Return the rounded Vector3.

	Round the Vector3 to the nearest number.
]=]
local function Round(VectorA: Vector3, Amount: number): Vector3
	return (Vector3.new(((math.round((VectorA.X) / (Amount))) * (Amount)),
		((math.round((VectorA.Y) / (Amount))) * (Amount)), ((math.round((VectorA.Z) / (Amount)))
		* (Amount)))) :: number
end

--[=[
	@within Vector

	@param VectorA Vector -- The vector.

	@param MaxMagnitude number -- The maximum magnitude.

	@return number -- Return the clamped magnitude.

	Clamp the magnitude of a vector so it is only a certain length.
]=]
local function ClampMagnitude(VectorA: Vector, MaxMagnitude: number): number
	return (((VectorA.Magnitude) > (MaxMagnitude)) and ((VectorA.Unit) * (MaxMagnitude)) or (VectorA))
		:: number
end

--[=[
	@within Vector

	@param VectorA Vector -- The initial vector.

	@param VectorB Vector -- The secondary vector.

	@return number -- Return the radianed angle.

	Finds the angle in radians between two vectors.
]=]
local function AngleBetween(VectorA: Vector, VectorB: Vector): number
	return (math.acos(math.clamp(VectorA.Unit:Dot(VectorB.Unit), -1, 1))) :: number
end

--[=[
	@within Vector

	@param VectorA Vector -- The primary vector.

	@param VectorB Vector -- The secondary vector.

	@param AxisVector Vector -- The axis vector.

	@return number -- Return the radianed angle.

	Finds the angle in radians between two vectors and returns a signed value.
]=]
local function AngleBetweenSigned(VectorA: Vector, VectorB: Vector, AxisVector: Vector): number
	local Angle: number = AngleBetween(VectorA, VectorB)

	return ((Angle) * (math.sign(AxisVector:Dot(VectorA:Cross(VectorB))))) :: number
end

--[=[
	@within Vector

	@return Vector3 -- Return the random Vector3.

	Return a random unit vector (could be used for equal distribution around a sphere).
]=]
local function GetRandomUnitVector(): Vector3
	local VariableA: number = ((2) * ((math.random()) - (0.5)))
	local VariableB: number = ((6.2831853071796) * (math.random()))
	local VariableC: number = (((1) - ((VariableA) * (VariableA))) ^ (0.5))

	local X: number = VariableA
	local Y: number = ((VariableC) * (math.cos(VariableC)))
	local Z: number = ((VariableC) * (math.sin(VariableB)))

	return (Vector3.new(X, Y, Z)) :: Vector3
end

--// Pascal patches
Vector.fromVector2XY = FromVector2XY
Vector.FromVector2XY = FromVector2XY

Vector.fromVector2XZ = FromVector2XZ
Vector.FromVector2XZ = FromVector2XZ

Vector.getAngleRad = GetAngleRad
Vector.GetAngleRad = GetAngleRad

Vector.angleBetweenVectors = AngleBetweenVectors
Vector.AngleBetweenVectors = AngleBetweenVectors

Vector.round = Round
Vector.Round = Round

Vector.clampMagnitude = ClampMagnitude
Vector.ClampMagnitude = ClampMagnitude

Vector.angleBetween = AngleBetween
Vector.AngleBetween = AngleBetween

Vector.angleBetweenSigned = AngleBetweenSigned
Vector.AngleBetweenSigned = AngleBetweenSigned

Vector.getRandomUnitVector = GetRandomUnitVector
Vector.GetRandomUnitVector = GetRandomUnitVector

return (Vector)