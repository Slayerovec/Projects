local VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)



RegisterServerEvent("Telegram:GetName")
AddEventHandler("Telegram:GetName", function(src)
	local _source

	if not src then
		_source = source
	else
		_source = src
	end

	local Character = VorpCore.getUser(_source).getUsedCharacter
	local name = { firstname = Character.firstname, lastname = Character.lastname }

	TriggerClientEvent("Telegram:Name", _source, name)
end)
RegisterServerEvent("Telegram:GetMessages")
AddEventHandler("Telegram:GetMessages", function(src)
	local _source
	
	if not src then 
		_source = source
	else 
		_source = src
	end

	local Character = VorpCore.getUser(_source).getUsedCharacter
	local recipient = Character.identifier

	exports.ghmattimysql:execute("SELECT * FROM telegrams WHERE recipient=@recipient ORDER BY id DESC", { ['@recipient'] = recipient }, function(result)
		TriggerClientEvent("Telegram:ReturnMessages", _source, result, 'recieved')
	end)
end)

RegisterServerEvent("Telegram:GetSendedMessages")
AddEventHandler("Telegram:GetSendedMessages", function(src)
	local _source

	if not src then
		_source = source
	else
		_source = src
	end

	local Character = VorpCore.getUser(_source).getUsedCharacter
	local senderID = Character.identifier

	exports.ghmattimysql:execute("SELECT * FROM telegrams WHERE senderID=@senderID ORDER BY id DESC", { ['@senderID'] = senderID }, function(result)
		TriggerClientEvent("Telegram:ReturnMessages", _source, result, Character.firstname, Character.lastname, 'sended')
	end)
end)

RegisterServerEvent("Telegram:ReadMessages")
AddEventHandler("Telegram:ReadMessages", function(id)
	exports.ghmattimysql:execute('UPDATE telegrams SET isRead=@isRead WHERE id=@id', {
		['@id'] = id,
		['@isRead'] = 1,
	})
end)

RegisterServerEvent("Telegram:SendMessage")
AddEventHandler("Telegram:SendMessage", function(firstname, lastname, message, price)
	local _source = source
	local Character = VorpCore.getUser(_source).getUsedCharacter
	local currentMoney = Character.money
	local sender = Character.firstname .. " " .. Character.lastname
	local senderID = Character.identifier

	exports.ghmattimysql:execute("SELECT identifier FROM characters WHERE firstname=@firstname AND lastname=@lastname", { ['@firstname'] = firstname, ['@lastname'] = lastname}, function(result)
		if result[1] then
			local recipient = result[1].identifier
			local reciever = firstname .. " " .. lastname
			local paramaters = { ['@sender'] = sender, ['@senderID'] = senderID, ['@recipient'] = recipient, ['@reciever'] = reciever, ['@message'] = message, ['@isRead'] = 0 }
			if currentMoney >= price then
				exports.ghmattimysql:execute("INSERT INTO telegrams (sender, senderID, recipient, reciever, message, isRead) VALUES (@sender, @senderID, @recipient, @reciever, @message, @isRead)",  paramaters, function()
					Character.removeCurrency(0, price)
					TriggerClientEvent("vorp:TipBottom", _source, "Odeslal si telegram!", 3000)
					if sender == reciever then
						TriggerClientEvent("vorp:TipBottom", _source, "Obdržel si telegram.", 3000)
					end
				end)
			else
				TriggerClientEvent("vorp:TipBottom", _source, "Nemáš dostatek peněz!", 3000)
			end
		else
			TriggerClientEvent("vorp:TipBottom", _source, "Zadal si špatné Jméno a Příjmení", 3000)
		end
	end)
end)

RegisterServerEvent("Telegram:DeleteMessage")
AddEventHandler("Telegram:DeleteMessage", function(id)
	local _source = source
	exports.ghmattimysql:execute("DELETE FROM telegrams WHERE id=@id",  { ['@id'] = id }, function()
		TriggerEvent("Telegram:GetMessages", _source)
	end)
end)