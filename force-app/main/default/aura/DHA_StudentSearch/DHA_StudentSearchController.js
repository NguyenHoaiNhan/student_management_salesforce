({
    init: function (cmp, event, helper) {
        helper.fetchClasses(cmp);
        helper.getStudentsWithConditions(cmp);
    },
    onSearch: function (cmp, event, helper) {
        if (helper.validateForm(cmp)) {
            helper.getStudentsWithConditions(cmp);
        };
    },
    onClear: function (cmp, event, helper) {
        helper.resetForm(cmp);
        helper.getStudentsWithConditions(cmp);
    },
    openModel: function (component, event, helper) {
        component.set("v.isModalOpen", true);
        const action = event.getParam('action');
        const row = event.getParam('row');

          
    },
    closeModal: function (component, event, helper) {
        component.set("v.isModalOpen", false);
    },
})