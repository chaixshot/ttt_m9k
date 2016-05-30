-- Variables that are used on both client and server
SWEP.Gun = ("m9k_1897winchester") -- must be the name of your swep but NO CAPITALS!
SWEP.Category				= "M9K Shotguns"
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Winchester 1897"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 2				-- Slot in the weapon selection menu
SWEP.SlotPos				= 3			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= false		-- set false if you want no crosshair
SWEP.Weight				= 3			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "shotgun"	-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= true
SWEP.ViewModel				= "models/weapons/v_1897trenchshot.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_winchester_1897_trench.mdl"	-- Weapon world model
SWEP.Base 				= "weapon_tttbase"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.AutoSpawnable      = true
SWEP.Primary.Delay = 0.8

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_SHOTGUN

SWEP.Primary.Sound			= Sound("Trench_97.Single")		-- script that calls the primary fire sound
SWEP.Primary.RPM				= 70		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 8			-- Size of a clip
SWEP.Primary.DefaultClip		       = 8	-- Default number of bullets in a clip
SWEP.Primary.ClipMax                      = 24
SWEP.Primary.KickUp				= 0.9				-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.6		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.4	-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "Buckshot"
SWEP.AmmoEnt = "item_box_buckshot_ttt"	-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Kind = WEAPON_HEAVY
SWEP.WeaponID = AMMO_SHOTGUN

SWEP.Secondary.IronFOV			= 60		-- How much you 'zoom' in. Less is more! 

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.ShellTime			= .6

SWEP.Primary.NumShots	= 5		//how many bullets to shoot, use with shotguns
SWEP.Primary.Damage		= 9  // base damage, scaled by game
SWEP.Primary.Spread		= .04	//define from-the-hip accuracy (1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .04 // has to be the same as primary.spread
-- Because irons don't magically give you less pellet spread!


SWEP.IronSightsPos = Vector(2.809, 0, 1.48)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.SightsPos = Vector(2.809, 0, 1.48)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(-3.116, -3.935, 0.492)
SWEP.RunSightsAng = Vector(-19.894, -47.624, 10.902)

if ((gmod.GetGamemode().Name) == "Murderthon 9000") or ((gmod.GetGamemode().Name) == "Murderthon 9000 beta") then
	SWEP.Primary.Ammo			= "slam"
else
	SWEP.Primary.Ammo			= "buckshot"
end

SWEP.reloadtimer = 0

function SWEP:SetupDataTables()
   self:DTVar("Bool", 0, "reloading")

   return self.BaseClass.SetupDataTables(self)
end

function SWEP:Reload()
   self:SetIronsights( false )
   
   --if self.Weapon:GetNetworkedBool( "reloading", false ) then return end
   if self.dt.reloading then return end

   if not IsFirstTimePredicted() then return end
   
   if self.Weapon:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 then
      
      if self:StartReload() then
         return
      end
   end

end

function SWEP:StartReload()
   --if self.Weapon:GetNWBool( "reloading", false ) then
   if self.dt.reloading then
      return false
   end

   if not IsFirstTimePredicted() then return false end

   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   
   local ply = self.Owner
   
   if not ply or ply:GetAmmoCount(self.Primary.Ammo) <= 0 then 
      return false
   end

   local wep = self.Weapon
   
   if wep:Clip1() >= self.Primary.ClipSize then 
      return false 
   end

   wep:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)

   self.reloadtimer =  CurTime() + wep:SequenceDuration()

   --wep:SetNWBool("reloading", true)
   self.dt.reloading = true

   return true
end

function SWEP:PerformReload()
   local ply = self.Owner
   
   -- prevent normal shooting in between reloads
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

   if not ply or ply:GetAmmoCount(self.Primary.Ammo) <= 0 then return end

   local wep = self.Weapon

   if wep:Clip1() >= self.Primary.ClipSize then return end

   self.Owner:RemoveAmmo( 1, self.Primary.Ammo, false )
   self.Weapon:SetClip1( self.Weapon:Clip1() + 1 )

   wep:SendWeaponAnim(ACT_VM_RELOAD)

   self.reloadtimer = CurTime() + wep:SequenceDuration()
end

function SWEP:FinishReload()
   self.dt.reloading = false
   self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
   
   self.reloadtimer = CurTime() + self.Weapon:SequenceDuration()
end

function SWEP:CanPrimaryAttack()
   if self.Weapon:Clip1() <= 0 then
      self:EmitSound( "Weapon_Shotgun.Empty" )
      self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
      return false
   end
   return true
end

function SWEP:Think()
   if self.dt.reloading and IsFirstTimePredicted() then
      if self.Owner:KeyDown(IN_ATTACK) then
         self:FinishReload()
         return
      end
      
      if self.reloadtimer <= CurTime() then

         if self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
            self:FinishReload()
         elseif self.Weapon:Clip1() < self.Primary.ClipSize then
            self:PerformReload()
         else
            self:FinishReload()
         end
         return            
      end
   end
end

function SWEP:Deploy()
   self.dt.reloading = false
   self.reloadtimer = 0
   return self.BaseClass.Deploy(self)
end

-- The shotgun's headshot damage multiplier is based on distance. The closer it
-- is, the more damage it does. This reinforces the shotgun's role as short
-- range weapon by reducing effectiveness at mid-range, where one could score
-- lucky headshots relatively easily due to the spread.
function SWEP:GetHeadshotMultiplier(victim, dmginfo)
   local att = dmginfo:GetAttacker()
   if not IsValid(att) then return 3 end

   local dist = victim:GetPos():Distance(att:GetPos())
   local d = math.max(0, dist - 140)
   
   -- decay from 3.1 to 1 slowly as distance increases
   return 1 + math.max(0, (2.1 - 0.002 * (d ^ 1.25)))
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