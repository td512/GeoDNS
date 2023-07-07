$(document).ready(function() {
	$('.reinstall').click(function() {
		medianame = $(this).data('medianame');
		modal = $('#install-modal');

		$('#vm_hostname', modal).val('');
		$('.medianame', modal).html(medianame);
		$('#vm_os').attr("value", medianame);

		modal.modal('show');

	});
  });
