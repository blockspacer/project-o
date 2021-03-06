ParticleEffect = {
	Properties = {
		soclasses_SmartObjectClass = "",
		ParticleEffect="",
		
		bActive=1,							-- Activate on startup
		bPrime=1,								-- Starts in equilibrium state, as if activated in past
		Scale=1,								-- Scale entire effect size.
		SpeedScale=1,						-- Scale particle emission speed
		CountScale=1,						-- Scale particle counts.
		bCountPerUnit=0,				-- Multiply count by attachment extent
		Strength=-1,						-- Custom param control
		esAttachType="",				-- BoundingBox, Physics, Render
		esAttachForm="Surface",	-- Vertices, Edges, Surface, Volume
		PulsePeriod=0,					-- Restart continually at this period.
	},
	Editor = {
		Model="Editor/Objects/Particles.cgf",
		Icon="Particles.bmp",
	},
	
	States = { "Active","Idle" },

	Client = {},
	Server = {},
};

Net.Expose {
	Class = ParticleEffect,
	ClientMethods = {
		ClEvent_Spawn = { RELIABLE_ORDERED, POST_ATTACH },
		ClEvent_Enable = { RELIABLE_ORDERED, POST_ATTACH },
		ClEvent_Disable = { RELIABLE_ORDERED, POST_ATTACH },
		ClEvent_Restart = { RELIABLE_ORDERED, POST_ATTACH },
		ClEvent_Kill = { RELIABLE_ORDERED, POST_ATTACH },
	},
	ServerMethods = {
	},
	ServerProperties = {
	},
};

-------------------------------------------------------
function ParticleEffect:OnLoad(table)
	if (not table.nParticleSlot) then
		self:GotoState("Idle");
	elseif (not self.nParticleSlot or self.nParticleSlot ~= table.nParticleSlot) then
		self:GotoState("Idle");
		self.nParticleSlot = self:LoadParticleEffect( table.nParticleSlot, self.Properties.ParticleEffect, self.Properties );
		self:GotoState("Active");
	end
end

-------------------------------------------------------
function ParticleEffect:OnSave(table)
  table.nParticleSlot = self.nParticleSlot;
end

-------------------------------------------------------
function ParticleEffect:OnPropertyChange()
	self:GotoState("");
	self:OnReset();
end

-------------------------------------------------------
function ParticleEffect:OnReset()
	self:GotoState( "Idle" );
	if (self.Properties.bActive ~= 0) then
		self:GotoState( "Active" );
	end
end

------------------------------------------------------------------------------------------------------
function ParticleEffect:Event_Enable()
	self:GotoState( "Active" );
	self:ActivateOutput( "Enable", true );

	if CryAction.IsServer() and self.allClients then
		self.allClients:ClEvent_Enable();
	end

end

function ParticleEffect:Event_Disable()
	self:GotoState( "Idle" );
	self:ActivateOutput( "Disable", true );

	if CryAction.IsServer() and self.allClients then
		self.allClients:ClEvent_Disable();
	end

end

function ParticleEffect:Event_Restart()
	self:GotoState( "Idle" );
	self:GotoState( "Active" );
	self:ActivateOutput( "Restart", true );

	if CryAction.IsServer() and self.allClients then
		self.allClients:ClEvent_Restart();
	end

end

function ParticleEffect:Event_Spawn()
	self:GetDirectionVector(1, g_Vectors.temp_v2); -- 1=forward vector
	Particle.SpawnEffect( self.Properties.ParticleEffect, self:GetPos(g_Vectors.temp_v1), g_Vectors.temp_v2, self.Properties.Scale );
	self:ActivateOutput( "Spawn", true );

	if CryAction.IsServer() and self.allClients then
		self.allClients:ClEvent_Spawn();
	end

end


function ParticleEffect:Event_Kill()
  self:DeleteParticleEmitter( self.nParticleSlot );
	self:ActivateOutput( "Kill", true );
	self:GotoState("Idle");
	if CryAction.IsServer() and self.allClients then
		self.allClients:ClEvent_Kill();
	end
end

function ParticleEffect:Enable()
	self:GotoState("Active");
	if CryAction.IsServer() and self.allClients then
		self.allClients:ClEvent_Enable();
	end
end

function ParticleEffect:Disable()
	self:GotoState("Idle");
	if CryAction.IsServer() and self.allClients then
		self.allClients:ClEvent_Disable();
	end
end
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Active State
-------------------------------------------------------------------------------
ParticleEffect.Active =
{
	OnBeginState = function( self )
	  if (not self.nParticleSlot) then
		  self.nParticleSlot = self:LoadParticleEffect( -1, self.Properties.ParticleEffect, self.Properties );
		end
	end,
	
	OnLeaveArea = function( self,entity,areaId )
		self:GotoState( "Idle" );
	end,
}

-------------------------------------------------------------------------------
-- Idle State
-------------------------------------------------------------------------------
ParticleEffect.Idle =
{
	OnBeginState = function( self )
	  if (self.nParticleSlot) then
		  self:FreeSlot(self.nParticleSlot);
		  self.nParticleSlot = nil;
	  end
	end,

	OnEnterArea = function( self,entity,areaId )
		self:GotoState( "Active" );
	end,
}

-- !!! net and states stuff
function ParticleEffect:DefaultState(cs, state)
	local default=self[state];
	self[cs][state]={
		OnBeginState = default.OnBeginState,
		OnEndState = default.OnEndState,
		OnLeaveArea = default.OnLeaveArea,
		OnEnterArea = default.OnEnterArea,
	}
end
-------------------------------------------------------
ParticleEffect:DefaultState("Server", "Idle");
ParticleEffect:DefaultState("Server", "Active");
ParticleEffect:DefaultState("Client", "Idle");
ParticleEffect:DefaultState("Client", "Active");

-------------------------------------------------------

ParticleEffect.FlowEvents =
{
	Inputs =
	{
		Disable = { ParticleEffect.Event_Disable, "bool" },
		Enable = { ParticleEffect.Event_Enable, "bool" },
		Restart = { ParticleEffect.Event_Restart, "bool" },
		Spawn = { ParticleEffect.Event_Spawn, "bool" },
		Kill = { ParticleEffect.Event_Kill, "bool" },
	},
	Outputs =
	{
		Disable = "bool",
		Enable = "bool",
		Restart = "bool",
		Spawn = "bool",
	},
}

-------------------------------------------------------
-- client functions
-------------------------------------------------------

-------------------------------------------------------
function ParticleEffect.Client:OnInit()
	self:SetRegisterInSectors(1);
	self:PreLoadParticleEffect( self.Properties.ParticleEffect );
	
	self:SetUpdatePolicy(ENTITY_UPDATE_POT_VISIBLE);
	--self:SetFlags(ENTITY_FLAG_CLIENT_ONLY, 0);

	if (self.Properties.bActive ~= 0) then
		self:GotoState( "Active" );
	else
		self:GotoState( "Idle" );
	end
	--self:NetPresent(nil);
end

-------------------------------------------------------
function ParticleEffect.Client:ClEvent_Spawn()
	if( not CryAction.IsServer() ) then
		self:Event_Spawn();
	end
end
-------------------------------------------------------
function ParticleEffect.Client:ClEvent_Enable()
	if( not CryAction.IsServer() ) then
		self:Event_Enable();
	end
end
-------------------------------------------------------
function ParticleEffect.Client:ClEvent_Disable()
	if( not CryAction.IsServer() ) then
		self:Event_Disable();
	end
end
-------------------------------------------------------
function ParticleEffect.Client:ClEvent_Restart()
	if( not CryAction.IsServer() ) then
		self:Event_Restart();
	end
end
-------------------------------------------------------
function ParticleEffect.Client:ClEvent_Kill()
	if( not CryAction.IsServer() ) then
		self:Event_Kill();
	end
end

