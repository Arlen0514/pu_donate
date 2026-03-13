		$(document).ready(function() {
			$("#start_date").dynDateTime({
				ifFormat:"%Y/%m/%d"
			});
			$("#end_date").dynDateTime({
				ifFormat:"%Y/%m/%d"
			}); 
			$("#_qemitdate").dynDateTime({
				ifFormat:"%Y/%m/%d"
			});
			$("#_qrestdate").dynDateTime({
				ifFormat:"%Y/%m/%d"
			});
		});