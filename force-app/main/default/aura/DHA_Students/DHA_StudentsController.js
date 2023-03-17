({
	checkDuplicateRecord: function (cmp, event, helper) {
		const allValid = helper.validForm(cmp);
		if (!allValid) {
			const toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				"title": "Success!",
				"type": "error",
				"message": "Please check again your information!",
				"duration": 5000,
			});
			toastEvent.fire();
			return;
		}

		helper.getDuplicateRecords(cmp);
		cmp.set('v.isCheckDup', true);
	},
	saveRecord: function (cmp, event, hepler) {
		const isDupChecked = cmp.get('v.isCheckDup');

		if (!isDupChecked) {
			const toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				"title": "Success!",
				"type": "error",
				"message": "Please check duplicated records first!",
				"duration": 5000,
			});
			toastEvent.fire();
			return;
		}

		cmp.set('v.isCheckDup', false);
	},
})