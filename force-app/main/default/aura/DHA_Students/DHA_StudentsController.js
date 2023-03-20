({
	init: function (cmp, event, helper) {
		helper.getAllClasses(cmp);
	},
	handleCheckBtn: function (cmp, event, helper) {
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
	handleSaveBtn: function (cmp, event, helper) {
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

		helper.saveRecord(cmp);
	},
	handleAssignBtn: function (cmp, event, helper) {
		if (cmp.get('v.isRecordSaved') === false) {
			const toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				"title": "Warning",
				"type": "warn",
				"message": "Create new record first!",
				"duration": 5000,
			});
			toastEvent.fire();
			return;
		}

		const selectedRows = cmp.find('selectableClasses').getSelectedRows();
		const classCodesToAssign = [];
		selectedRows.forEach((val) => {
			classCodesToAssign.push(val.classCode);
		});
		if (selectedRows.length !== 0) {
			helper.assignClasses(cmp, classCodesToAssign);
			return;
		}

		const toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"title": "Warning",
			"type": "warn",
			"message": "Please choose at least one class to assign!",
			"duration": 5000,
		});
		toastEvent.fire();
	},
	hanleFormChange: function (cmp, event, helper) {
		cmp.set('v.isRecordSaved', false);
		cmp.set('v.isCheckDup', false);
		cmp.set('v.studentIdSaved', null)
	},
})