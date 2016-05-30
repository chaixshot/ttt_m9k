SWEP.AutoSpawnable      = true-- Variables that are used on both client and server
SWEP.Gun = ("m9k_deagle") -- must be the name of your swep but NO CAPITALS!
SWEP.Category				= "M9K Pistols"
SWEP.Author				= "iron angles and models hexed and converted to gmod my Mr Fokkusu"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.Icon = "vgui/entities/m9k_deagle.vmt"
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Desert Eagle .40"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 1				-- Slot in the weapon selection menu
SWEP.SlotPos				= 5			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= false		-- set false if you want no crosshair
SWEP.Weight				= 3			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "pistol"		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles
SWEP.AdminSpawnable = true

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_tcom_deagle.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_tcom_deagle.mdl"	-- Weapon world model
SWEP.Base				= "weapon_tttbase"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Kind = WEAPON_PISTOL
SWEP.WeaponID = AMMO_DEAGLE

SWEP.Primary.Sound			= Sound("Weapon_TDegle.Single")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 600			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 8		-- Size of a clip
SWEP.Primary.DefaultClip		= 8		-- Bullets you start with
SWEP.Primary.ClipMax            = 37    -- Evens shit out
SWEP.Primary.KickUp				= 1		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.5		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.5		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "AlyxGun"
SWEP.AmmoEnt = "item_ammo_revolver_ttt"			-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.IronFOV			= 55		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 30	-- Base damage per bullet
SWEP.Primary.Spread		= .025	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .015 -- Ironsight accuracy, should be the same for shotguns

-- Enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector (-1.7102, 0, 0.2585)
SWEP.IronSightsAng = Vector (0, 0, 0)
SWEP.SightsPos = Vector (-1.7102, 0, 0.2585)
SWEP.SightsAng = Vector (0, 0, 0)
SWEP.RunSightsPos = Vector(3.444, -7.823, -6.27)
SWEP.RunSightsAng = Vector(60.695, 0, 0)
-- SWEP.RunSightsPos = Vector (-0.3967, 0, 2.2339)
-- SWEP.RunSightsAng = Vector (-17.3454, -2.6248, 0)

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