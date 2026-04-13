from netbox.authentication import Group # For NetBox >= 4.0.0

class AuthFailed(Exception):
    pass

def add_groups(response, user, backend, *args, **kwargs):
    try:
        groups = response['groups']
    except KeyError:
        pass

    # Add all groups from OAuth token
    for group in groups:
        group, created = Group.objects.get_or_create(name=group)
        user.groups.add(group) # For NetBox >= 4.0.0

def remove_groups(response, user, backend, *args, **kwargs):
    try:
        groups = response['groups']
    except KeyError:
        # Remove all groups if no groups in OAuth token
        user.groups.clear()
        pass

    # Get all groups for user
    user_groups = [item.name for item in user.groups.all()]
    # Get user groups that are not part of the OAuth token
    delete_groups = list(set(user_groups) - set(groups))

    # Delete groups not included in the OAuth token
    for delete_group in delete_groups:
        group = Group.objects.get(name=delete_group)
        user.groups.remove(group) # For NetBox >= 4.0.0


def set_roles(response, user, backend, *args, **kwargs):
    # Remove Roles temporarily
    user.is_superuser = False
    user.is_staff = False
    try:
        groups = response['groups']
    except KeyError:
        # When no groups are set
        # save the user without Roles
        user.save()
        pass

    # Set roles when role groups (superuser or staff) are present
    user.is_superuser = True if 'superusers' in groups else False
    user.is_staff = True if 'staff' in groups else False
    user.save()