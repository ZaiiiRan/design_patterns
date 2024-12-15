function toggleTextField(selectId, textFieldId) {
    const selectElement = document.getElementById(selectId);
    const textField = document.getElementById(textFieldId);
    if (selectElement.value === 'yes') {
        textField.disabled = false;
    } else {
        textField.disabled = true;
    }
}

document.getElementById('git-select').addEventListener('change', function() {
    toggleTextField('git-select', 'git-text-field');
});
document.getElementById('email-select').addEventListener('change', function() {
    toggleTextField('email-select', 'email-text-field');
});
document.getElementById('phone-select').addEventListener('change', function() {
    toggleTextField('phone-select', 'phone-text-field');
});
document.getElementById('telegram-select').addEventListener('change', function() {
    toggleTextField('telegram-select', 'telegram-text-field');
});

toggleTextField('git-select', 'git-text-field');
toggleTextField('email-select', 'email-text-field');
toggleTextField('phone-select', 'phone-text-field');
toggleTextField('telegram-select', 'telegram-text-field');