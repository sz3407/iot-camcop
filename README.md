# CamCop

As the world becomes increasingly interconnected, the threat of cyberbullying looms larger than ever before. From hurtful messages on social media to the theft of personal information, the digital age has opened up a new frontier for bullies to harass and intimidate their victims. 

But perhaps the most insidious form of cyberbullying is the unauthorized access of someone's webcam. It's a violation of privacy that can leave people feeling vulnerable and exposed in the very places they should feel safest, like their bedrooms or private offices. 

That's where CamCop comes in. With its cutting-edge technology, this innovative project sends an instant notification to your mobile device via Slack every time your laptop camera is turned on. With CamCop, you can rest easy knowing that you have an extra layer of protection against cyber criminals and the potential violation of your privacy. 

No longer do you have to worry about hackers lurking in the shadows, waiting to take advantage of your vulnerability. CamCop is here to help you take back control and ensure that your digital life remains your own. So why wait? Sign up for CamCop today and experience the peace of mind that comes with knowing that you're always protected.

Method
We use the basic idea that every process that runs on your laptop can be accessed from the terminal or the command line. With this in mind, first we decided on what operating systems we wanted to work with.

Device Selection
For our project we chose to work with macOS and Windows. We did this because most of the people we talk to everyday, irrespective of their background, usually use one of these two. In our research we also found that, as of April 2023, Windows is the most used operating system on laptops, with a market share of 69%. macOS is the second most popular operating system, with a market share of 17%. Chrome OS is the third most popular operating system, with a market share of 3.2%. Linux is the fourth most popular operating system, with a market share of 2.9%. 

So we focused our efforts on developing solutions for users of these platforms, primarily. 

Application Development
For the scanning functionality of CamCop, we employed native logging tools provided by both the macOS and Windows operating systems. This approach was inspired by a similar technique utilized by Oversight, a third-party application for macOS that monitors for microphone and camera events. To identify our logger conditions, we collected an unfiltered session of system logs during which we activated several camera applications. These logs were scanned for relevant events and the content was used to test various iterations of the filter. We also included details like device name, collected from system applications like device manager or system profiler.

log stream
  --predicate 'subsystem=="com.apple.cmio"'
  --predicate 'sender contains "appleh13camerad"'
  --predicate 'composedMessage contains "CMIOExtensionProperty"'

These are some examples of filter properties tested for detecting camera events.

When the user launches CamCop, the application will first deploy python to the system if it is not previously installed, as this is an underlying requirement for triggering our response actions. If an event occurs while CamCop is running, a script file is called to generate the notification. The file is passed along the event log contents from which it can determine the state change and application name that caused the activation. To provide a more informative alert, these details are embedded in the message sent to the user’s device.

os_ = sys.platform
pid = sys.argv[6]
process_info = subprocess.run('ps -p ' + pid, stdout=subprocess.PIPE, shell=True)
app_ = ' '.join(sys.argv[8:])

This is the script file inside CamCop that can parse information from the event log contents and make a system call to identify the responsible application from its process id (PID).

We designed CamCop to support two methods of delivery for the mobile alerts. During development we used Pushover, which relies on an established connection between your phone and their notification services. This was suitable for our purposes, however they limit users to a 30-day trial period before requiring a paid subscription. For our user testing we also created a Slack workspace where notifications were aggregated to expedite the demonstration of CamCop.
