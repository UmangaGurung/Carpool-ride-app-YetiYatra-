document.querySelectorAll('.edit-role-btn').forEach(button => {
    button.addEventListener('click', function() {
        const username = this.getAttribute('data-username');
        const row = document.getElementById(`user-${username}`);
        const roleSelect = row.querySelector('.edit-role');
        const roleSpan = row.querySelector('.user-role');
        const saveButton = row.querySelector('.save-role-btn');

        roleSelect.style.display = 'inline';
        roleSpan.style.display = 'none';
        saveButton.style.display = 'inline';

        saveButton.addEventListener('click', async function() {
            const newRole = roleSelect.value;
            try {
                const response = await fetch('/admin/updaterole', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ username, isAdmin: newRole })
                });
                const result = await response.json();
                if (response.ok) {
                    roleSpan.textContent = newRole === 'true' ? 'Admin' : 'User';
                    roleSpan.style.display = 'inline';
                    roleSelect.style.display = 'none';
                    saveButton.style.display = 'none';
                    alert(result.message);
                } else {
                    alert(result.message);
                }
            } catch (error) {
                console.error('Error updating role:', error);
            }
        });
    });
});
