import http.client, urllib, sys, json, subprocess

#get system platform
os_ = sys.platform #[Windows: win32], [macOS: darwin]

# fetch pushover strings
try:
	filename = "pushover.json"
	pushover = open(filename)
	pdata = json.load(pushover)
	pushover.close()
except FileNotFoundError:
	err_msg = "Pushover Keys file <" + filename + "> not found.\nPlease refer to setup instructions for creating this file."
	print(err_msg)
	sys.exit()

def doMac():
	# get pid
	pid = sys.argv[6]

	# identify event type (start|stop)
	event_type = ""
	for arg in sys.argv:
		if ("CMIODeviceStartStream" in arg):
			event_type = "started"
		elif ("CMIODeviceStopStream" in arg):
			event_type = "stopped"

	# identify launching application
	app_concat = ""
	for arg in sys.argv[8:]:
		if (arg == "(CoreMediaIO)"):
			break
		else:
			app_concat = app_concat + arg + " "
	app_concat = app_concat[:-2]

	return (app_concat, event_type)

def sendPushoverNotif(app_concat="", event_type=""):
	mac_msg = app_concat + " application just " + event_type + " your webcam!"
	win_msg = "CamCop running on your Windows machine has detected a camera event."
	conn = http.client.HTTPSConnection("api.pushover.net:443")
	conn.request("POST", "/1/messages.json",
	urllib.parse.urlencode({
		"token": pdata["token"],
		"user": pdata["user"],
		"message": mac_msg if (os_=='darwin') else win_msg
	}), { "Content-type": "application/x-www-form-urlencoded" })
	conn.getresponse()

def sendSlackNotif():
	slack_msg = "text=Your camera was just (de)activated. Did you do that?"
	channel = "channel=C054SAU5KNC"
	token = "xoxb-5162368159648-5166676343475-OyHlIUnjtE2VnnSJvyaO6E9e"
	bash_cmd = 'curl -d "' + slack_msg + '" -d "' + channel + '" -H "Authorization: Bearer ' + token + '" -X POST https://slack.com/api/chat.postMessage'
	subprocess.run(bash_cmd, stdout=subprocess.PIPE, shell=True)

# ************** main actions ************** #

# macOS platform
if (os_ == 'darwin'):
	result = doMac()
	sendPushoverNotif(result[0], result[1])
	sendSlackNotif()
# windows platform
elif (os_ == 'win32'):
	sendPushoverNotif()
	sendSlackNotif()
else:
	print("Unsupported operating system.")

# ****************** end ****************** #