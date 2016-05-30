AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

SWEP.Weight				= 30		// Decides whether we should switch from/to this
SWEP.AutoSwitchTo			= true		// Auto switch to 
SWEP.AutoSwitchFrom			= true		// Auto switch from

function SWEP:Initialize()
end

function SWEP:OnRemove()
end

-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
   if not self.IronSightsPos then return end
   if self:GetNextSecondaryFire() > CurTime() then return end

   local bIronsights = not self:GetIronsights()

   self:SetIronsights( bIronsights )

   if SERVER then
      self:SetZoom( bIronsights )
   end

   self:SetNextSecondaryFire( CurTime() + 0.3 )
end
function SWEP:SetZoom(state)
   if CLIENT then return end
   if not (IsValid(self.Owner) and self.Owner:IsPlayer()) then return end
   if state then
      self.Owner:SetFOV(75, 0.5)
   else
      self.Owner:SetFOV(0, 0.2)
   end
end
function SWEP:PreDrop()
   self:SetZoom(false)
   self:SetIronsights(false)
   return self.BaseClass.PreDrop(self)
end
function SWEP:Holster()
   self:SetIronsights(false)
   self:SetZoom(false)
   return true
end
--end zoom