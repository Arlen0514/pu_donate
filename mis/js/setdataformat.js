		$(document).ready(function() {
			$("#start_data").dynDateTime({
				ifFormat:"%Y/%m/%d"
			});
			$("#deadline_data").dynDateTime({
				ifFormat:"%Y/%m/%d"
			}); 
			$("#_qemitdate").dynDateTime({
				ifFormat:"%Y/%m/%d"
			});
			$("#_qrestdate").dynDateTime({
				ifFormat:"%Y/%m/%d"
			}); 
		});