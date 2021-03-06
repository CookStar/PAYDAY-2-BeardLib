LocalizationModule = LocalizationModule or class(ModuleBase)

--Need a better name for this
LocalizationModule.type_name = "Localization"

function LocalizationModule:init(core_mod, config)
    if not self.super.init(self, core_mod, config) then
        return false
    end
    self.LocalizationDirectory = self._config.directory and BeardLib.Utils.Path:Combine(self._mod.ModPath, self._config.directory) or self._mod.ModPath

    self.Localizations = {}

    for _, tbl in ipairs(self._config) do
        if tbl._meta == "localization" or tbl._meta == "loc" then
            self.Localizations[Idstring(tbl.language):key()] = tbl.file
        end
    end

    self.DefaultLocalization = self._config.default or self.Localizations[1]

    self:RegisterHooks()

    return true
end

function LocalizationModule:RegisterHooks()
    Hooks:Add("LocalizationManagerPostInit", self._mod.Name .. "_Localization", function(loc)
        if self.Localizations[SystemInfo:language():key()] then
            LocalizationManager:load_localization_file(BeardLib.Utils.Path:Combine(self.LocalizationDirectory, self.Localizations[SystemInfo:language():key()]))
        else
            LocalizationManager:load_localization_file(BeardLib.Utils.Path:Combine(self.LocalizationDirectory, self.DefaultLocalization))
        end
	end)
end

BeardLib:RegisterModule(LocalizationModule.type_name, LocalizationModule)
