local Hello = {}

function Hello.message(environment: string): string
	return string.format("[Rojo] %s code is connected and running!", environment)
end

return Hello
