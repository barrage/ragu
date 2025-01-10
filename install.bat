# Change to the script directory
Set-Location -Path $PSScriptRoot

# Function to prompt for yes/no input
function Prompt-YesNo {
    param (
        [string]$Message
    )
    while ($true) {
        $response = Read-Host "$Message [y/N]"
        $response = $response.ToLower()
        if ($response -eq "y" -or $response -eq "yes") {
            return $true
        } elseif ($response -eq "n" -or $response -eq "no" -or $response -eq "") {
            return $false
        } else {
            Write-Host "Invalid input. Please enter 'y' or 'n'."
        }
    }
}

# initialize and update submodules
git submodule init
if ($LASTEXITCODE -ne 0) { exit 1 }

git submodule update
if ($LASTEXITCODE -ne 0) { exit 1 }

# Build the images, start the services
docker-compose up -d
if ($LASTEXITCODE -ne 0) { exit 1 }

# even though we use OAuth initial admin account must be created to be able to login
if (Prompt-YesNo "Do you want to create the initial admin account?") {
    $admin_email = Read-Host "Enter admin email (must be a valid OAuth provider email otherwise you will not be able to login)"

    Invoke-RestMethod -Uri 'http://localhost:42070/dev/users' -Method Post -ContentType 'application/json' -Body @{
        email = $admin_email
        fullName = "Admin Admin"
        firstName = "Admin"
        lastName = "Admin"
        role = "admin"
    } | ConvertTo-Json
}

Write-Host "Thank you for trying Ragu, now that you have completed the initial setup you can manage the Ragu stack with docker-compose"