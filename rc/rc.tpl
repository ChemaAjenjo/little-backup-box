<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
     <link href="https://fonts.googleapis.com/css?family=Lato" rel="stylesheet">

     p.left {
         text-align: left;
     }
     p.center {
         text-align: center;
     }
     img {
	 display: block;
	 margin-left: auto;
	 margin-right: auto;
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
         width: 11em;  height: 2em;
         background: #3399ff;
         border-radius: 5px;
         color: #fff;
         font-family: 'Lato', sans-serif; font-size: 25px; font-weight: 900;
         letter-spacing: 3px;
         border:none;
     }
     #btn.orange {
         background: #ff9900;
     }
     #btn.red {
         background: #cc0000;
     }
    </style> 
</head>
<title>Little Backup Box</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<form method="POST" action="/">
    <div id="content">
	<div id="header"><img src="static/ichigo.svg" height="39px" alt="Ichigo" align=""> Little Backup Box</div>
	<p class="center">Free disk space on <i>/home</i>: <b>{{freespace_home}}</b> GB</p>
	<hr>
	<!--<p class="left">Back up a storage card connected via a card reader</p>
	<p><input id="btn" name="cardbackup" type="submit" value="Card backup"></p>-->
	<p class="left">Trasfiere los fichero directamente desde la camara conectada</p>
	<p><input id="btn" name="camerabackup" type="submit" value="Camara backup"></p>
	<p class="left">Mueve los ficheros almacenados en la raspberry al dispositivo conectado</p>
	<p><input id="btn" name="devicebackup" type="submit" value="Copiar a HDD"></p>
	<p class="left">Transfiere los fichero del lector de tarjetas al almacenamiento interno</p>
	<p><input id="btn" name="readerbackup" type="submit" value="Lector backup"></p>
	<p class="left">Sube los ficheros del almacenamiento interno a la nube</p>
	<p><input id="btn" class="orange" name="networkbackup" type="submit" value="Cloud backup"></p>
	<p class="left">Apaga la raspberry</p>
	<p><input id="btn" class="red" name="shutdown" value="Shut down" type="submit" /></p>
    </div>
