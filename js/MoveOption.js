
/**
 * MoveOption.js
 * Move the option upward or downward.
 * 選項向上移動或向下移動一個位置.
 * @author Marco wei
 * @date 2013/9/22 02:21 上午
 */

/**
 * Move the option upward 1 position.
 * 將選項向上移動一個位置.
 * @param SELECT A <select> object.
 */
function goup(SELECT) {
    // Options count. 選項的數目.
    var opts = SELECT.options.length;
    // 選項的內容值及顯示文字的暫存變數
    var buf_value = "";
    var buf_text  = "";
    // Selected value. 選擇的選項值.
    var selectedvalue = SELECT.value;
    // Get the index of options. 選擇的選項索引.
    var i = 0;
    
    for (i = 0; i < opts; i++) {
    	if ((selectedvalue == SELECT.options[i].value) && (i != 0)) {
    		buf_value = SELECT.options[i].value;
    		SELECT.options[i].value = SELECT.options[i-1].value;
    		SELECT.options[i-1].value = buf_value;
    		
    		buf_text = SELECT.options[i].text;
    		SELECT.options[i].text = SELECT.options[i-1].text;
    		SELECT.options[i-1].text = buf_text;
    		
    		SELECT.options[i-1].selected = "selected";
    		break;
    	}
    }
}

/**
 * Move the option downward 1 position.
 * 將選項向下移動一個位置.
 * @param SELECT A <select> object.
 */
function godn(SELECT) {
    // Options count. 選項的數目.
    var opts = SELECT.options.length;
    // 選項的內容值及顯示文字的暫存變數
    var buf_value = "";
    var buf_text  = "";
    // Selected value. 選擇的選項值.
    var selectedvalue = SELECT.value;
    // Get the index of options. 選擇的選項索引.
    var i = 0;
    
    for (i = 0; i < opts; i++) {
    	if ((selectedvalue == SELECT.options[i].value) && (i != (opts - 1))) {
    		buf_value = SELECT.options[i].value;
    		SELECT.options[i].value = SELECT.options[i+1].value;
    		SELECT.options[i+1].value = buf_value;
    		
    		buf_text = SELECT.options[i].text;
    		SELECT.options[i].text = SELECT.options[i+1].text;
    		SELECT.options[i+1].text = buf_text;
    		
    		SELECT.options[i+1].selected = "selected";
    		break;
    	}
    }
    
}
