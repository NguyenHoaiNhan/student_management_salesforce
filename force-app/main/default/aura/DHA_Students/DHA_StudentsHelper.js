({
	getDuplicateRecords: function (cmp) {
		const action = cmp.get('c.findDuplicatedRecords');
		action.setParams({
			name: cmp.get('v.nameToSearch'),
			birthdate: cmp.get('v.birthdateToSearch'),
			address: cmp.get('v.addressToSearch'),
			gender: cmp.get('v.genderToSearch'),
			email: cmp.get('v.emailToSearch'),
		});

		action.setCallback(this, (response) => {
			const state = response.getState();
			if (state == "SUCCESS") {
				let data = [];
				response.getReturnValue().forEach((val) => {
					let temp = val;
					temp.CreatedDate = val.CreatedDate.toString().substring(0, 10);
					data.push(temp);
				});
				cmp.set('v.numberOfDup', 'We found ' + data.length + ' possible duplicate record(s)');
				cmp.set('v.tableData', data);
			}
		});
		$A.enqueueAction(action);
	},
	saveRecord: function (cmp) {
		const action = cmp.get('c.insertStudent');
		action.setParams({
			name: cmp.get('v.nameToSearch'),
			birthdate: cmp.get('v.birthdateToSearch'),
			address: cmp.get('v.addressToSearch'),
			gender: cmp.get('v.genderToSearch'),
			email: cmp.get('v.emailToSearch'),
		});

		action.setCallback(this, (response) => {
			const state = response.getState();
			if (state == "SUCCESS") {
				cmp.set('v.isRecordSaved', true);
				cmp.set('v.studentIdSaved', response.getReturnValue());
				const toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"title": "Success!",
					"type": "success",
					"message": "Successfully",
					"duration": 5000,
				});
				toastEvent.fire();
			} else if (state == "ERROR") {
				const errors = response.getError();
				if (errors) {
					const toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						"title": "Error!",
						"type": "error",
						"message": 'Add new student unsuccessfully',
						"duration": 5000,
					});
					toastEvent.fire();
				} else {
					console.log('Unknown error');
				}
			}
		});
		$A.enqueueAction(action);
	},
	validForm: function (cmp) {
		const allValid = cmp.find('form-input').reduce(function (validSoFar, inputCmp) {
			inputCmp.reportValidity();
			return validSoFar && inputCmp.checkValidity();
		}, true);
		return allValid;
	},
	getAllClasses: function (cmp) {
		const action = cmp.get('c.getClasses');
		action.setCallback(this, (response) => {
			const state = response.getState();
			if (state == "SUCCESS") {
				let data = [];
				response.getReturnValue().forEach((val) => {
					const temp = {
						classCode: val.Name,
						memberCount: val.DHA_Class_Assignments__r.length,
						startDate: val.Start_Date__c,
						endDate: val.End_Date__c,
					};
					data.push(temp);
				});
				cmp.set('v.classTable', data);
			}
		});
		$A.enqueueAction(action);
	},
	assignClasses: function (cmp, classesToAssign) {
		const action = cmp.get('c.assignStudent');
		action.setParams({
			studentId: cmp.get('c.studentIdSaved'),
			classCodes: classesToAssign,
		});

		action.setCallback(this, (response) => {
			const state = response.getState();
			if (state == "SUCCESS") {
				const toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"title": "Success!",
					"type": "success",
					"message": "Successfully",
					"duration": 5000,
				});
				toastEvent.fire();

				cmp.set('v.isRecordSaved', false);
				cmp.set('v.isCheckDup', false);
				cmp.set('v.studentIdSaved', null);
			}
			else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log("Error message: " +
							errors[0].message);
					}
				} else {
					console.log("Unknown error");
				}
			}
			else {
				console.log('unknown error');
			}
		});
		$A.enqueueAction(action);
	},
})