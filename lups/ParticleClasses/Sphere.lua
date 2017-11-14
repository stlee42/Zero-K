-- $Id: gimmick1.lua 3171 2008-11-06 09:06:29Z det $
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

local Sphere = {}
Sphere.__index = Sphere

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

function Sphere.GetInfo()
  return {
    name      = "Sphere",
    backup    = "", --// backup class, if this class doesn't work (old cards,ati's,etc.)
    desc      = "",

    layer     = -24, --// extreme simply z-ordering :x

    --// gfx requirement
    fbo       = false,
    shader    = false,
    rtt       = false,
    ctt       = false,
  }
end

Sphere.Default = {
  pos        = {0,0,0},
  layer      = -24,
  life       = math.huge,
  repeatEffect = true,
}

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

function Sphere:BeginDraw()
  gl.DepthMask(false)
  gl.Lighting(true)
  gl.Light(0, true )
  gl.Light(0, GL.POSITION, gl.GetSun() )
  gl.Light(0, GL.AMBIENT, gl.GetSun("ambient","unit") )
  gl.Light(0, GL.DIFFUSE, gl.GetSun("diffuse","unit") )
  gl.Light(0, GL.SPECULAR, gl.GetSun("specular") )
  --gl.Culling(GL.BACK)
end

function Sphere:EndDraw()
  gl.DepthMask(false)
  gl.Lighting(false)
  gl.Light(0, false)
end

function Sphere:Draw()
  local pos  = self.pos
  gl.Translate(pos[1],pos[2],pos[3])

  gl.Color(0.5,0.5,0.5,0.5)
  gl.Material({
    ambient   = {0.5,0.5,0.5,1},
    diffuse   = {1,1,1,0.5},
    specular  = {1,1,1,0.5},
    shininess = 120,
  })

  gl.Scale(self.size, self.size, self.size)
  gl.CallList(self.SphereList)
end

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

function Sphere:Initialize()
  Sphere.SphereList  = gl.CreateList(DrawSphere,0,0,0,1,30)
end

function Sphere:Finalize()
  gl.DeleteList(Sphere.SphereList)
end

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

function Sphere:CreateParticle()
  self.firstGameFrame = Spring.GetGameFrame()
  self.dieGameFrame   = self.firstGameFrame + self.life
end

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

function Sphere:Update()
end

-- used if repeatEffect=true;
function Sphere:ReInitialize()
  self.dieGameFrame = self.dieGameFrame + self.life
end

function Sphere.Create(Options)
  local newObject = MergeTable(Options, Sphere.Default)
  setmetatable(newObject,Sphere)  -- make handle lookup
  newObject:CreateParticle()
  return newObject
end

function Sphere:Destroy()
end

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

return Sphere