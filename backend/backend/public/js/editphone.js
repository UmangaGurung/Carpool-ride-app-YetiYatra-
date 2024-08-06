document.querySelectorAll('.edit-phone-btn').forEach(button => {
    button.addEventListener('click', function() {
        const username = this.getAttribute('data-username');
        const row = document.getElementById(`user-${username}`);
        const phoneInput = row.querySelector('.edit-phone');
        const phoneSpan = row.querySelector('.phone-number');
        const saveButton = row.querySelector('.save-phone-btn');

        phoneInput.style.display = 'inline';
        phoneSpan.style.display = 'none';
        saveButton.style.display = 'inline';

        saveButton.addEventListener('click', async function() {
            const newPhone = phoneInput.value;
            try {
                const response = await fetch('/admin/updatephone', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ username, phone: newPhone })
                });
                const result = await response.json();
                if (response.ok) {
                    phoneSpan.textContent = newPhone;
                    phoneSpan.style.display = 'inline';
                    phoneInput.style.display = 'none';
                    saveButton.style.display = 'none';
                    alert(result.message);
                } else {
                    alert(result.message);
                }
            } catch (error) {
                console.error('Error updating phone:', error);
            }
        });
    });
});
