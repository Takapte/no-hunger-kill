fx_version 'adamant'
games { 'gta5' }

author 'Takapté'
description 'Script QBCore qui régule le niveau de faim et de soif lorsqu\'il atteint un seuil critique, afin d\'éviter la mort.'
version '1.0'

client_script 'client/*.lua'
server_script 'server/*.lua'

dependencies {
    'qb-core'
}

lua54 'yes'
