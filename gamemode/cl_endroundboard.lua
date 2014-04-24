

local menu



local textTab = {"Melonbomber is a game where you try to elimate the other players with explosive melons while grabbing upgrades to increase your power", Color(255, 0, 0),
"Based on the game Bomberman, Melonbomber brings the same hectic, fast paced gameplay to GMod. ", Color(0, 255, 0), "Players can place explosive melons and use them to kill other players or destroy wooden crates around the map. Inside the crates can be found powerups that can give you an edge on other players."}

concommand.Add("ph_endroundmenu", function ()
	if IsValid(menu) then
		menu:SetVisible(true)
		return
	end

	menu = vgui.Create("DFrame")
	menu:SetSize(ScrW() * 0.95, ScrH() * 0.95)
	menu:Center()
	menu:SetTitle("")
	menu:MakePopup()
	-- menu:SetKeyboardInputEnabled(false)
	menu:SetDeleteOnClose(false)
	menu:SetDraggable(false)
	menu:ShowCloseButton(true)
	menu:DockPadding(8, 8, 8, 8)

	local matBlurScreen = Material( "pp/blurscreen" )
	function menu:Paint(w, h)
		DisableClipping(true)

		local x, y = self:LocalToScreen( 0, 0 )

		local Fraction = 0.4

		surface.SetMaterial( matBlurScreen )	
		surface.SetDrawColor( 255, 255, 255, 255 )

		for i=0.33, 1, 0.33 do
			matBlurScreen:SetFloat( "$blur", Fraction * 5 * i )
			matBlurScreen:Recompute()
			if ( render ) then render.UpdateScreenEffectTexture() end
			surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
		end
		
		surface.SetDrawColor(40,40,40,230)
		surface.DrawRect(-x, -y, ScrW(), ScrH())

		DisableClipping(false)
	end

	local pnl = vgui.Create("DPanel", menu)
	pnl:Dock(LEFT)
	function pnl:PerformLayout()
		self:SetWide(menu:GetWide() * 0.5)
	end

	function pnl:Paint(w, h)
		surface.SetDrawColor(20, 20, 20, 150)
		surface.DrawRect(0, 0, w, h)
	end

	local sayPnl = vgui.Create("DPanel", pnl)
	sayPnl:Dock(BOTTOM)
	sayPnl:DockPadding(2, 2, 2, 2)
	sayPnl:SetTall(draw.GetFontHeight("RobotoHUD-15") + 4)

	local entry = vgui.Create("DTextEntry", sayPnl)
	entry:Dock(FILL)
	entry:SetFont("RobotoHUD-15")
	function entry:OnEnter(...)
		RunConsoleCommand("say", self:GetValue())
		self:SetText("")
	end


	local mlist = vgui.Create("DScrollPanel", pnl)
	menu.ChatList = mlist
	mlist:Dock(FILL)
	function mlist:Paint(w, h)
	end

	// child positioning
	local canvas = mlist:GetCanvas()
	canvas:DockPadding(0, 0, 0, 0)
	function canvas:OnChildAdded( child )
		child:Dock(TOP)
		child:DockMargin(0, 0, 0, 1)
	end

	-- GAMEMODE:EndRoundAddChatText("Words of radiance", Color(255, 0 ,0), "then red text", "then more", " and more", Color(0, 255, 0), " green with a space")
end)

function GM:EndRoundAddChatText(...)
	if !IsValid(menu) then
		return
	end

	local pnl = vgui.Create("DPanel")
	pnl.Text = {...}
	function pnl:PerformLayout()
		if self.Text then
			self.TextLines = WrapText("RobotoHUD-15", self:GetWide() - 16, self.Text)
		end
		if self.TextLines then
			self:SetTall(self.TextLines.height)
		end
	end

	function pnl:Paint(w, h)
		surface.SetDrawColor(255, 0, 0, 255)
		surface.DrawOutlinedRect(0, 0, w, h)
		if self.TextLines then
			self.TextLines:Paint(4, draw.GetFontHeight("RobotoHUD-15") * -0.2)
		end
	end
	menu.ChatList:AddItem(pnl)
end