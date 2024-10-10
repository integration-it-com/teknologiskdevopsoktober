# Tak for sidst

Hej Kursist

Her er lidt information fra kurset

# Azure DevOps Sandbox (Integration-IT) 

- Adresse:	https://dev.azure.com/integration-it-teaching/  
- Username: 	teknologiskdevops@adminintegrationit.onmicrosoft.com
- Kodeord:	Teknologisk1234!

Denne konto bliver lukket 14 dage efter oprettelse, da der så skal MFA på og så kan I ikke bruge denne mere ;)

# Git materiale

I kan finde det Git Repo, som vi endte ud med her:
https://github.com/integration-it-com/teknologiskdevopsoktober

Bemærk: Jeg bruger faktisk GitHub her (næsten det samme som Azure DevOps Repos), da denne Repo er public ;)

# Pipelines
Hvis man skal prøve at opsætte Pipelines på et senere tidspunkt, så skal man bruge en `Variable Group`, der hedder `Common`. Denne skal indeholde følgende variabler (værdier er fra kurset):

- `appName`: `teknodevops`
- `location`: `germanywestcentral`
- `sc.prod`: `sc.test` (Nej, ikke en fejl ;) )
- `sc.test`: `sc.test`

De her `sc.test` og `sc.prod` værdier er navnet på den service connection (service-bruger), der har adgang fra Azure DevOps til Azure Services.

Læs mere her: https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops

