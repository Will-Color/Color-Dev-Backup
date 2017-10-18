({
    saveCont : function(component, event) {
        component.find("contactRec").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS"){
                component.set("v.recordSaveMsg",false);
                setTimeout(function(){ 
                    component.set("v.recordSaveMsg",true);
                }, 1500);
            }
        }));
    }
})