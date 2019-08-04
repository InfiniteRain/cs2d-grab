--Grab system V 2.1 by Factis699--
--You able to grab if only ur usgn in admin list
--To grab someone you need first of all turn grab state ON with F2 (server action 1)
--Then click to someone to grab him (attack 1)
--To place him click again (attack 1)

--Changelog:
--Now you cant grab yourself!

--Admin list
adminlist = {16770} -- Your USGN ID here
--E.G. adminlist = {16770, 25678} 

--Array function
function array(m, d)
	local a = {}
	for id = 1, m do
		a[id] = d
	end
	return a
end

--arrays
mousex = array(32, 0)
mousey = array(32, 0)
grabstate = array(32, 0)
grabbedby = array(32, 0)
grabbedvictim = array(32, 0)
reason = array(32, 0)


--hooks
print(string.char(169) .. '255255000Hooks Initialising...')
addhook('serveraction', 'menuCall')
addhook('menu', 'menuCheck')
addhook('attack', 'sendClientData')
addhook('clientdata', 'getGrab')
addhook('ms100', 'followMouse')
addhook('die', 'dieUnGrab')

print(string.char(169) .. '255255000Hooks initialising finished')

print(string.char(169) .. '255255000Function initialising...')

--functions
print(string.char(169) .. '255255255Call menu')
function menuCall(id, action)
	if action == 1 then
		for adm = 1, #adminlist do
			if player(id, 'usgn') == adminlist[adm] then
				if grabstate[id] == 0 then
					menu(id, 'Turn grab ON, Turn ON')
				elseif grabstate[id] == 1 then
					menu(id, 'Turn grab OFF, Turn OFF')
				end
			end
		end
	end
end

print(string.char(169) .. '255255255Check menu')

function menuCheck(id, title, button)
	if title == 'Turn grab ON' then
		grabstate[id] = 1
	elseif title == 'Turn grab OFF' then
		grabstate[id] = 0
	end
end

print(string.char(169) .. '255255255Send client data')

function sendClientData(id)
	if grabbedvictim[id] ~= 0 then
		parse('speedmod '.. grabbedvictim[id] ..' 0')
		grabbedby[grabbedvictim[id]] = 0
		grabbedvictim[id] = 0
	elseif grabbedvictim[id] == 0 and grabstate[id] == 1 then
		reason[id] = 1
		reqcld(id, 2)
	end
end

print(string.char(169) .. '255255255Get client data')

function getGrab(id, mode, data1, data2)
	if grabstate[id] == 1 and mode == 2 then
		if reason[id] == 1 then
			mousex[id] = math.floor(data1/32)
			mousey[id] = math.floor(data2/32)
			for p = 1, 32 do
				if player(p, 'tilex') == mousex[id] and player(p, 'tiley') == mousey[id] then
					if grabbedvictim[id] == 0 then
						if grabbedvictim[p] == 0 then
							grabbedvictim[id] = p
							grabbedby[p] = id
						else
							msg2(string.char(169) .. '255000000You cant grab him, he already grab someone!')
						end
					end
				end
			end
		end
		if reason[id] == 2 then
			if grabbedvictim[id] ~= id then
				mousex[id] = math.floor(data1/32)
				mousey[id] = math.floor(data2/32)
				parse('speedmod '.. grabbedvictim[id] ..' -100')
				parse('setpos '.. grabbedvictim[id] ..' '.. mousex[id] * 32 + 16 ..' '.. mousey[id] * 32 + 16)
			else
				msg2(id, 'You cant grab yourself!')
				grabbedby[grabbedvictim[id]] = 0
				grabbedvictim[id] = 0
			end
		end
	end
end

print(string.char(169) .. '255255255Get mouse data')

function followMouse()
	for id = 1, 32 do
		if grabbedby[id] ~= 0 then
			reason[grabbedby[id]] = 2
			reqcld(grabbedby[id], 2)
		end
	end
end

print(string.char(169) .. '255255255Die ungrab')

function dieUnGrab(victim, killer, weapon, x, y)
	if grabbedvictim[victim] ~= 0 then
		parse('speedmod '.. grabbedvictim[victim] ..' 0')
		grabbedvictim[victim] = 0
		grabbedby[grabbedvictim[victim]] = 0
	end
	if grabbedby[victim] ~= 0 then
		parse('speedmod '.. victim ..' 0')
		grabbedvictim[grabbedby[victim]] = 0
		grabbedby[victim] = 0
	end
end

print(string.char(169) .. '255255000Function initialising finished')

print(string.char(169) .. '255255000Script loaded succesfully!')
--Need help in lua?
--Pm me
--US login: Factis699
--Enjoy my script!