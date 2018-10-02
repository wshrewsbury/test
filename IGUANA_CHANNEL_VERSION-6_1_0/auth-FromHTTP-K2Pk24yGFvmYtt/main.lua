function main(Data)
   -- Get the request details
   local Request = net.http.parseRequest{data = Data}
   local name = Request.params['name'] or "UNKNOWN"
   local password = Request.params['password']
 
   local success = false
 
   success, roles = validateViaPasswd(name, password)
 
   if success then
      body = '1'
      for _, role in pairs(roles) do
         body = body .. '\r\n' .. role
      end
   else
      body = '0'
   end
 
   local Response = net.http.respond{
      body = body,
      entity_type = "text/plain",
      debug_result = true,
      use_gzip = false,
   }
 
   iguana.logInfo('Returning "' .. body .. '" for: ' .. name)
end
 
-- Plaintext 'passwd' style authentication
function validateViaPasswd(name, password)
   local passwd = {
      ['wade#wade'] = 'pass&word',
   }
 
   isGoodPassword = false
   for uid, p in pairs(passwd) do
      if name == uid then
         -- Found a matching UID to the name.
         if password == p then
            -- And passwords match.
            isGoodPassword = true
            break
         end
      end
   end
 
   return isGoodPassword, getRoles(name)
end
 
function getRoles(name)
   local roles = {}
 
   -- Only some users are Admins
   if name == 'wade#wade' or name == 'admin' then
      roles = {
         "Administrators",
         "Iguana Administrators",
      }
   else
      roles = {
         "Users",
         "Iguana Users",
      }
   end
 
   return roles
end