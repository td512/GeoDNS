function scorpio_status() {

	$.get('/vm/'+serverid+'/status')
		.done(function(data) {

			var section = '';
			switch(data.status) {
				case 'running':

					$('.server-status').html('<span class="label label-success">ONLINE</span>');

				break;
				case 'shutoff':

					$('.server-status').html('<span class="label label-important">OFFLINE</span>');

				break;
				default:
					$('.server-status').html('<span class="label label-important">STATUS UNKNOWN</span>');
				break;
			}
		});
	}
	$('#vm-controls .zone-boot').click(function() {
  if(confirm('Are you sure you want to start your server?')) {
	$.get('/vm/'+serverid+'/start')
		.done(function() {
		scorpio_status();
	});
	}
});
 $('#vm-controls .zone-reset').click(function() {
   if(confirm('Are you sure you want to restart your server?')) {
	 $.get('/vm/'+serverid+'/restart')
	 .done(function() {
		 scorpio_status();
	 });
 }
});
$('#vm-controls .zone-poweroff').click(function() {
	if(confirm('Are you sure you want to stop your server?')) {
	$.get('/vm/'+serverid+'/stop')
	.done(function() {
		scorpio_status();
	});
}
});
$('.launchconsole').click(function() {

		window.open($(this).attr('href'),'', 'scrollbars=no,location=no,status=no,toolbar=no,menubar=no,width=640,height=550');

		return false;

	});
//scorpio_status();
window.setInterval(scorpio_status, 1000);
