<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
     <link href="https://fonts.googleapis.com/css?family=Lato" rel="stylesheet">

     p.left {
         text-align: left;
     }
     p.center {
         text-align: center;
		 margin: 5 auto;
     }
     img {
	 display: block;
	 margin-left: auto;
	 margin-right: auto;
     }
	 h2 {
	 margin: 5 auto;
	 }
     #content {
		 font: 1em/1.5em 'Lato', sans-serif;
         margin: 0px auto;
         width: 275px;
         text-align: left;
     }
     #header {
	 font: bold 1.7em/2em 'Lato', sans-serif;
	 text-align: center;
     }
     #btn {
        border-radius: 10px;
        letter-spacing: 3px;
        cursor:pointer;
        width: 275px;
        height: 100px;
        border: 3px solid;
     }
     #btn.orange {
         border-color: #ff9900;
     }
     #btn.red {
        border-color: #cc0000;
     }
	 #btn.green {
         border-color: green;
     }
	 #btn.blue {
		border-color: #3399ff;
	 }
	 #btn.btn-reader-backup {
        background:url(/static/reader-backup.png) no-repeat;
     }
	 #btn.btn-camera-backup {
        background:url(/static/camera-backup.png) no-repeat;
     }
	 #btn.btn-device-backup {
        background:url(/static/device-backup.png) no-repeat;
     }
	 #btn.btn-card-backup {
        background:url(/static/card-backup.png) no-repeat;
     }
	 #btn.btn-network-backup {
        background:url(/static/network-backup.png) no-repeat;
     }
	 #btn.btn-device-2-network-backup {
        background:url(/static/device-2-network-backup.png) no-repeat;
     }
	 #btn.btn-shutdown{
        background: url(/static/shutdown.png) no-repeat;
		background-color: #cc0000;
	 }
    </style> 
</head>
<title>Little Backup Box</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<form method="POST" action="/">
    <div id="content">
	<div id="header"><h2>{{hostname}}</h2></div>
	<p class="center">Free disk space on <i>/home</i>: <b>{{freespace_home}}</b> GB</p>
	<hr>
	<div id="header">Internal Storage</div>
	<p><input id="btn" class="btn-camera-backup blue" name="camerabackup" value=" " type="submit"></p>
	<p><input id="btn" class="btn-reader-backup blue" name="readerbackup" value=" " type="submit"></p>
	<div id="header">External Storage</div>
	<p><input id="btn" class="btn-device-backup orange" name="devicebackup" value=" " type="submit"></p>
	<p><input id="btn" class="btn-card-backup orange" name="cardbackup" value=" " type="submit"></p>
	<div id="header">Network Storage</div>
	<p><input id="btn" class="btn-network-backup green" name="networkbackup" value=" " type="submit"></p>
	<p><input id="btn" class="btn-device-2-network-backup green" name="device-2-network-backup" value=" " type="submit"></p>
	<hr>
	<p><input id="btn" class="btn-shutdown red" name="shutdown" value=" " type="submit" /></p>
    </div>
