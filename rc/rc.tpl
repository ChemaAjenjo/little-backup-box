<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" type="text/css" href="static/styles.css">
</head>
<title>Little Backup Box</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<form method="POST" action="/">
<div id="content">
<div id="header"><h2>{{hostname}}</h2></div>
<p class="center">Free disk space on <i>/home</i>: <b>{{freespace_home}}</b> GB</p>
<hr>
<div id="header">Internal Storage</div>
<p><input id="btn" class="btn-camera-backup blue" name="camerabackup" value=" " type="submit" alt="Camera Backup"></p>
<p><input id="btn" class="btn-reader-backup blue" name="readerbackup" value=" " type="submit" alt="Reader Backup"></p>
<div id="header">External Storage</div>
<p><input id="btn" class="btn-device-backup orange" name="devicebackup" value=" " type="submit" alt="Device Backup"></p>
<!--
<p><input id="btn" class="btn-card-backup orange" name="cardbackup" value=" " type="submit"></p>
-->
<div id="header">Network Storage</div>
<p><input id="btn" class="btn-network-backup green" name="networkbackup" value=" " type="submit"></p>
<!--
<p><input id="btn" class="btn-device-2-network-backup green" name="device-2-network-backup" value=" " type="submit"></p>
-->
<p><input id="btn" class="red" name="confignetwork" value="Config Network" type="submit"></p>
<hr>
<p><input id="btn" class="btn-shutdown red" name="shutdown" value=" " type="submit" /></p>
</div>
